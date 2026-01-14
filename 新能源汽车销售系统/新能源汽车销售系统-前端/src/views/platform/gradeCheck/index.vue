<template>
  <div class="app-container">



    <!-- 表格数据 -->

    <el-table v-loading="loading" :data="topicList">
      <el-table-column label="课题" align="center" prop="topic" />
      <el-table-column label="指导成绩" align="center" prop="gradeInstruct" />
      <el-table-column label="评阅成绩" align="center" prop="gradeReview" />
      <el-table-column label="答辩成绩" align="center" prop="gradeDefence" />
      <el-table-column label="总成绩" align="center" prop="grade" />

    </el-table>

  </div>

</template>



<script>


import { delUser, getUserProfile } from '@/api/system/user'
import {
  addPaperManage,
  delPaperManage, getGradeListForStudent, getGradeListForTeacher,
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
      // 表格数据
      topicList:[],

    }
  },

  methods: {
    getList() {
      getGradeListForStudent().then(response => {
        // console.log(response);
        this.topicList = [response.data];
        console.log(this.topicList);
        console.log(this.topicList.topic);
        this.loading = false;

      })
    },



  }
}
</script>
