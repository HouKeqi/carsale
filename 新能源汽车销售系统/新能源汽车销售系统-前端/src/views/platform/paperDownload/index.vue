<template>
  <!-- 学生选择课题 -->
  <div class="app-container">
    <!-- 学生选择最多3个课题-->

    <el-table :data="tableData" style="width: 100%">
      <el-table-column prop="opening" label="毕业论文" v-if="false"></el-table-column>

<!--      <el-table-column prop="opening" label="毕业论文">-->
<!--        <template slot-scope="scope">-->
<!--          <a :href="scope.row.opening" target="_blank">{{ scope.row.opening }}</a>-->
<!--        </template>-->
<!--      </el-table-column>-->


      <el-table-column prop="name" label="学生姓名" ></el-table-column>
      <el-table-column prop="studentId" label="学生学号" ></el-table-column>
      <el-table-column prop="status" label="状态" ></el-table-column>
      <el-table-column label="操作" >
        <template v-slot="scope">
<!--          <el-button type="primary" @click="download(scope.row.opening)" >论文下载</el-button>-->
          <a :href="'/dev-api/common/download/resource?resource='+scope.row.opening"  style="font-family: Arial, sans-serif; font-size: 18px; color: blue;">论文下载</a>
        </template>
      </el-table-column>
      <el-table-column label="审核" >
        <template v-slot="scope">
          <el-button type="primary" @click="pass_opening(scope.row.studentId)" >通过</el-button>
          <el-button type="primary" @click="not_pass_opening(scope.row.studentId)" >不通过</el-button>
        </template>
      </el-table-column>


    </el-table>

  </div>

</template>



<script>


import { downloadFile, getOpeningPaperListForTeacher, updatePaperUpload } from '@/api/platform/paperUpload'

export default{
  created() {
    this.getList();
  },

  data() {
    return {
      user: {},
      // 遮罩层
      loading: true,
      // 表格数据
      tableData:null,

      formData: {
        mobile: '',
        field101: null,
      },

      fileList:[],



    }
  },

  methods: {

    getList() {
      // 显示上传信息
      getOpeningPaperListForTeacher().then(response => {
        this.tableData = response.data
        this.loading = false
      })
    },


    pass_opening(studentId){
      updatePaperUpload({studentId:studentId,status:'已通过'}).then(response => {
        this.$modal.msgSuccess("审核成功");
        this.getList()
      })
    },

    not_pass_opening(studentId){
      updatePaperUpload({studentId:studentId,status:'未通过'}).then(response => {
        this.$modal.msgSuccess("审核成功");
        this.getList()
      })
    }

  },

}
</script>



