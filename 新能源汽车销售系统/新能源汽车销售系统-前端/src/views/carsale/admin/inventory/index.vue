<template>
  <div class="app-container">
    <el-alert
      title="库存预警"
      type="warning"
      :description="`当前有 ${lowStockCount} 款车型库存不足（≤5）`"
      show-icon
      :closable="false"
      style="margin-bottom: 20px"
    />

    <el-table v-loading="loading" :data="vehicleList">
      <el-table-column label="车辆编号" align="center" prop="id" />
      <el-table-column label="车型名称" align="center" prop="name" />
      <el-table-column label="品牌" align="center" prop="brand" />
      <el-table-column label="指导价" align="center" prop="price">
        <template slot-scope="scope">
          ¥{{ scope.row.price?.toLocaleString() }}
        </template>
      </el-table-column>
      <el-table-column label="当前库存" align="center" prop="stock">
        <template slot-scope="scope">
          <span :style="{ color: scope.row.stock <= 5 ? '#f56c6c' : '' }">
            {{ scope.row.stock }}
          </span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" width="200">
        <template slot-scope="scope">
          <el-button size="mini" type="text" @click="handleUpdateStock(scope.row)">调整库存</el-button>
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

    <!-- 调整库存对话框 -->
    <el-dialog title="调整库存" :visible.sync="stockOpen" width="400px" append-to-body>
      <el-form ref="stockForm" :model="stockForm" :rules="stockRules" label-width="100px">
        <el-form-item label="车型名称">
          <el-input v-model="stockForm.name" disabled />
        </el-form-item>
        <el-form-item label="当前库存">
          <el-input-number v-model="stockForm.stock" :min="0" style="width: 100%" disabled />
        </el-form-item>
        <el-form-item label="调整后库存" prop="newStock">
          <el-input-number v-model="stockForm.newStock" :min="0" style="width: 100%" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitStockForm">确 定</el-button>
        <el-button @click="stockOpen = false">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getLowStockList, getLowStockCount, updateStock } from '@/api/carsale/inventory'

export default {
  name: 'InventoryManage',
  data() {
    return {
      loading: false,
      total: 0,
      vehicleList: [],
      lowStockCount: 0,
      stockOpen: false,
      stockForm: {
        id: null,
        name: null,
        stock: null,
        newStock: null
      },
      stockRules: {
        newStock: [{ required: true, message: '请输入调整后库存', trigger: 'blur' }]
      },
      queryParams: {
        pageNum: 1,
        pageSize: 10
      }
    }
  },
  created() {
    this.getList()
    this.getCount()
  },
  methods: {
    getList() {
      this.loading = true
      getLowStockList(this.queryParams).then(response => {
        this.vehicleList = response.rows
        this.total = response.total
        this.loading = false
      })
    },
    getCount() {
      getLowStockCount().then(response => {
        this.lowStockCount = response.data.count
      })
    },
    handleUpdateStock(row) {
      this.stockForm = {
        id: row.id,
        name: row.name,
        stock: row.stock,
        newStock: row.stock
      }
      this.stockOpen = true
    },
    submitStockForm() {
      this.$refs['stockForm'].validate(valid => {
        if (valid) {
          updateStock({
            id: this.stockForm.id,
            stock: this.stockForm.newStock
          }).then(() => {
            this.$modal.msgSuccess('库存调整成功')
            this.stockOpen = false
            this.getList()
            this.getCount()
          })
        }
      })
    }
  }
}
</script>
