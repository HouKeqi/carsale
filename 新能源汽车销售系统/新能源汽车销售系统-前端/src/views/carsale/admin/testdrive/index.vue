<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="审核状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择审核状态" clearable>
          <el-option label="待审核" :value="0" />
          <el-option label="通过" :value="1" />
          <el-option label="拒绝" :value="2" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-table v-loading="loading" :data="testdriveList">
      <el-table-column label="预约编号" prop="id" width="180" />
      <el-table-column label="用户ID" prop="userId" width="100" />
      <el-table-column label="车型ID" prop="vehicleId" width="100" />
      <el-table-column label="预约门店" prop="storeName" />
      <el-table-column label="预约时间" prop="appointTime" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.appointTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="审核状态" prop="status" width="100">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.carsale_testdrive_status" :value="scope.row.status" />
        </template>
      </el-table-column>
      <el-table-column label="审核时间" prop="auditTime" width="180">
        <template slot-scope="scope">
          <span v-if="scope.row.auditTime">{{ parseTime(scope.row.auditTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="审核备注" prop="auditRemark" />
      <el-table-column label="操作" width="200" align="center">
        <template slot-scope="scope">
          <el-button
            v-if="scope.row.status === 0"
            size="mini"
            type="text"
            style="color: #67c23a"
            @click="handleAudit(scope.row, 1)"
          >通过</el-button>
          <el-button
            v-if="scope.row.status === 0"
            size="mini"
            type="text"
            style="color: #f56c6c"
            @click="handleAudit(scope.row, 2)"
          >拒绝</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination
      v-show="total > 0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />

    <!-- 审核对话框 -->
    <el-dialog title="审核试驾预约" :visible.sync="auditOpen" width="500px" append-to-body>
      <el-form ref="auditForm" :model="auditForm" label-width="100px">
        <el-form-item label="审核结果">
          <el-radio-group v-model="auditForm.status">
            <el-radio :label="1">通过</el-radio>
            <el-radio :label="2">拒绝</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="审核备注">
          <el-input v-model="auditForm.auditRemark" type="textarea" :rows="3" placeholder="请输入审核备注" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitAudit">确 定</el-button>
        <el-button @click="auditOpen = false">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getAdminTestdriveList, auditTestdrive } from '@/api/carsale/testdrive'
import { parseTime } from '@/utils/ruoyi'

export default {
  name: 'AdminTestdrive',
  dicts: ['carsale_testdrive_status'],
  data() {
    return {
      loading: false,
      showSearch: true,
      total: 0,
      testdriveList: [],
      auditOpen: false,
      auditForm: {
        id: null,
        status: 1,
        auditRemark: null
      },
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        status: null
      }
    }
  },
  created() {
    this.getList()
  },
  methods: {
    getList() {
      this.loading = true
      getAdminTestdriveList(this.queryParams).then(response => {
        this.testdriveList = response.rows
        this.total = response.total
        this.loading = false
      })
    },
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    resetQuery() {
      this.resetForm('queryForm')
      this.handleQuery()
    },
    handleAudit(row, status) {
      this.auditForm = {
        id: row.id,
        status: status,
        auditRemark: null
      }
      this.auditOpen = true
    },
    submitAudit() {
      auditTestdrive(this.auditForm.id, this.auditForm).then(() => {
        this.$modal.msgSuccess('审核成功')
        this.auditOpen = false
        this.getList()
      })
    }
  }
}
</script>
