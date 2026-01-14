<template>
  <div class="app-container">


    <!-- 表格数据 -->

    <el-table v-loading="loading" :data="topicList" >
      <el-table-column label="题目" align="center" prop="topic" />
      <el-table-column label="类型" align="center" prop="type" />
      <el-table-column label="要求" align="center" prop="ask" />
      <el-table-column label="学生姓名" align="center" prop="name" />
      <el-table-column label="学生学号" align="center" prop="student_id" />
      <el-table-column label="状态" align="center">
        <template slot-scope="scope">
          <span>{{ getStatus(scope.row.bond) }}</span>
        </template>
      </el-table-column>

      <el-table-column label="操作" width="180" >
        <template v-slot="scope" >
          <el-button type="primary" size="small"
                     @click="pass_Select(scope.row)" v-if="scope.row.bond === null || scope.row.bond === '0'">通过</el-button>
          <el-button type="danger" size="small" @click="not_pass_Select(scope.row)" v-if="scope.row.bond !== null && scope.row.bond !== '0'">未通过</el-button>
        </template>
      </el-table-column>

    </el-table>

  </div>

</template>



<script>


import { delUser, getUserProfile } from '@/api/system/user'
import {
  addPaperManage,
  delPaperManage,
  getPaperManage, getPaperManageForTeacher,
  listPaperManage,
  updatePaperManage, updatePaperManageBondInfoByTeacher
} from '@/api/platform/paperManage'

export default{
  created() {
    this.getList();
  },

  data() {
    return {
      user: {},
      // 遮罩层
      loading: true,
      // 表单参数
      form: {},
      // 表格数据
      topicList:null,
    }
  },

  methods: {
    getList() {
      getPaperManageForTeacher().then(response => {
        console.log(response);
        this.topicList = response.rows;
        this.total = response.total;
        this.loading = false;

      });
    },


    /** 表单重置 */
    reset() {
      this.form = {
        type: null,
        topic: null,
        ask: null,
      };
      this.resetForm("form");
    },

    /** 论文审核通过 按钮操作 */
    pass_Select(row){
      this.$modal.confirm('是否确认绑定？').then(function() {
        return updatePaperManageBondInfoByTeacher({bond:row.student_id,topic:row.topic});
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("审核成功");
      }).catch(() => {});
    },

    /** 论文审核不通过 按钮操作 */
    not_pass_Select(row){
      this.$modal.confirm('是否确认不绑定？').then(function() {
        return updatePaperManageBondInfoByTeacher({bond:"0",topic:row.topic});
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("审核成功");
      }).catch(() => {});
    },

    getStatus(bond) {
      if (bond === null) {
        return '未审核';
      } else if (bond !== null && bond !== "0") {
        return '已绑定';
      } else {
        return '未通过';
      }
    }

  }
}
</script>
