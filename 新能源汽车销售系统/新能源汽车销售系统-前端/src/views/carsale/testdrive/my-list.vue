<template>
  <div class="app-container">
    <el-table v-loading="loading" :data="testdriveList">
      <el-table-column label="预约编号" prop="id" width="180" />
      <el-table-column label="车型" prop="vehicleId" width="150">
        <template slot-scope="scope">
          <span v-if="vehicleMap[scope.row.vehicleId]">
            {{ vehicleMap[scope.row.vehicleId].brand }} {{ vehicleMap[scope.row.vehicleId].name }}
          </span>
        </template>
      </el-table-column>
      <el-table-column label="预约门店" prop="storeName" />
      <el-table-column label="预约时间" prop="appointTime" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.appointTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="审核状态" prop="status" width="120">
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
      <el-table-column label="操作" width="150" align="center">
        <template slot-scope="scope">
          <el-button
            v-if="scope.row.status === 0"
            size="mini"
            type="text"
            style="color: #f56c6c"
            @click="handleCancel(scope.row.id)"
          >取消预约</el-button>
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
  </div>
</template>

<script>
import { getMyTestdriveList, cancelTestdrive } from '@/api/carsale/testdrive'
import { searchVehicle } from '@/api/carsale/vehicle'
import { parseTime } from '@/utils/ruoyi'

export default {
  name: 'MyTestdriveList',
  dicts: ['carsale_testdrive_status'],
  data() {
    return {
      loading: false,
      total: 0,
      testdriveList: [],
      vehicleMap: {},
      queryParams: {
        pageNum: 1,
        pageSize: 10
      }
    }
  },
  created() {
    this.getList()
  },
  methods: {
    getList() {
      this.loading = true
      getMyTestdriveList(this.queryParams).then(response => {
        this.testdriveList = response.rows
        this.total = response.total
        this.loadVehicleInfo()
        this.loading = false
      })
    },
    loadVehicleInfo() {
      const vehicleIds = [...new Set(this.testdriveList.map(t => t.vehicleId))]
      if (vehicleIds.length > 0) {
        searchVehicle({ pageNum: 1, pageSize: 100 }).then(response => {
          response.rows.forEach(v => {
            this.vehicleMap[v.id] = v
          })
        })
      }
    },
    handleCancel(id) {
      this.$modal.confirm('确认取消该预约？').then(() => {
        return cancelTestdrive(id)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess('取消成功')
      })
    }
  }
}
</script>
