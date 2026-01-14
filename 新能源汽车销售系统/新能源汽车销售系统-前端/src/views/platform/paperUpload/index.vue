<template>
  <!-- 学生选择课题 -->
  <div class="app-container">
    <!-- 上传按钮 -->
    <el-form ref="elForm" :model="formData"  size="medium" label-width="10px">
      <el-form-item prop="field101" required>
        <el-upload ref="field101" :file-list="fileList" action="" :on-change="changeFile"  :auto-upload="false" >
          <el-button size="small" type="primary" icon="el-icon-upload">点击上传</el-button>
        </el-upload>


        <div style="display: flex; justify-content: flex-end;">
          <el-button class="sub-btn" size="small" type="primary" @click.native.prevent="Upload">提交</el-button>
        </div>

      </el-form-item>
    </el-form>

    <el-table :data="tableData" style="width: 100%">
      <el-table-column prop="opening" label="毕业论文" />
      <el-table-column prop="status" label="状态" />
    </el-table>

  </div>

</template>



<script>


import { getOpeningPaperList, uploadFile, uploadFileToDB } from '@/api/platform/paperUpload'

export default{
  created() {
    this.getList();
  },

  data() {
    return {
      // 遮罩层
      loading: true,

      // 表格数据
      tableData: [],

      formData: {
        mobile: '',
        field101: null,
      },

      form: {
        versionCode: '',
        descript: '',
        file: '' // file文件
      },

      fileList:[],
    }
  },

  methods: {

    getList() {
      // 显示上传信息
      getOpeningPaperList().then(response => {
        this.tableData = [response.data];
        console.log(this.tableData.opening)
        console.log(this.tableData.status)
        this.loading = false

      })
    },



    changeFile (file) {
      this.form.file = file.raw
    },


    Upload () {
      const loading = this.$loading({ lock: true, text: '文件上传中请稍等...', spinner: 'el-icon-loading', background: 'rgba(0, 0, 0, 0.7)' })
//将需要提交的文件，和附带的数据，append  FormData中 然后提交
      let formData = new FormData()
      formData.append('file', this.form.file)
      uploadFile(formData).then(response =>
      {
         uploadFileToDB({opening:response.fileName}).then(response =>
          {
            loading.close()
            this.$modal.msgSuccess("上传成功");
            this.formReset()// 上传成功清空
            this.getList()
          })
      })

    },

    formReset() { // 重置
      this.form = {
        versionCode: '',
        descript: '',
        file: '' // file文件
      }
    }



  },

}
</script>
