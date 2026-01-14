<template>
  <div class="app-container">



    <el-dialog title="请录入学生成绩" :visible.sync="dialogFormVisible" width="35%">
      <el-form :model="form">
        <el-form-item label="指导成绩" label-width="15%">
          <el-input v-model="form.gradeInstruct" autocomplete="off" style="width: 90%"></el-input>
        </el-form-item>
        <el-form-item label="评阅成绩" label-width="15%">
          <el-input v-model="form.gradeReview" autocomplete="off" style="width: 90%"></el-input>
        </el-form-item>
        <el-form-item label="答辩成绩" label-width="15%">
          <el-input v-model="form.gradeDefence" autocomplete="off" style="width: 90%"></el-input>
        </el-form-item>
      </el-form>

      <div slot="footer" class="dialog-footer">
        <el-button type="info" style="color:blue" @click="dialogFormVisible = false">取 消</el-button>
        <el-button type="primary" @click="submit()">确 定</el-button>
      </div>
    </el-dialog>







    <!-- 表格数据 -->

    <el-table v-loading="loading" :data="topicList">
      <el-table-column label="学生姓名" align="center" prop="name" />
      <el-table-column label="学号" align="center" prop="bond" />
      <el-table-column label="课题" align="center" prop="topic" />
      <el-table-column label="指导成绩" align="center" prop="gradeInstruct" />
      <el-table-column label="评阅成绩" align="center" prop="gradeReview" />
      <el-table-column label="答辩成绩" align="center" prop="gradeDefence" />
      <el-table-column label="总成绩" align="center" prop="grade" />

      <el-table-column label="操作" width="180" >
        <template v-slot="scope" >
          <el-button type="primary" size="small"
                     @click="Inputgrade(scope.row)" >录入</el-button>
        </template>
      </el-table-column>

    </el-table>

  </div>

</template>



<script>


import { delUser, getUserProfile } from '@/api/system/user'
import {
  addPaperManage,
  delPaperManage, getGradeListForTeacher,
  getPaperManage,
  listPaperManage,
  updatePaperManage, updatePaperManageBondInfoByTeacher
} from '@/api/platform/paperManage'

export default{
  created() {
    this.getList();
  },

  data() {
    return {
      // 遮罩层
      loading: true,
      // 打开对话框
      dialogFormVisible:false,
      // 表单参数
      form: {},
      // 表格数据
      topicList:[],

    }
  },

  methods: {
    getList() {
      getGradeListForTeacher().then(response => {
        // console.log(response);
        this.topicList = response.rows;
        // console.log(this.topicList);
        this.total = response.total;
        this.loading = false;
      })
    },

    Inputgrade(row){
      this.form = row;
      this.dialogFormVisible = true;
    },

    submit(){
      console.log(this.form);
      updatePaperManageBondInfoByTeacher(this.form).then(res=>{
        this.$modal.msgSuccess("操作成功");
        this.dialogFormVisible = false;
        this.getList();
      })
    },


  }
}
</script>
