<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="活动名称" prop="title">
        <el-input
          v-model="queryParams.title"
          placeholder="请输入活动名称"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="活动状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择活动状态" clearable>
          <el-option label="下架" :value="0" />
          <el-option label="上架" :value="1" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['carsale:promotion:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate" v-hasPermi="['carsale:promotion:edit']">修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete" v-hasPermi="['carsale:promotion:remove']">删除</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="promotionList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="活动编号" align="center" prop="id" />
      <el-table-column label="活动名称" align="center" prop="title" />
      <el-table-column label="关联车型ID" align="center" prop="vehicleId" />
      <el-table-column label="优惠类型" align="center" prop="discountType">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.carsale_discount_type" :value="scope.row.discountType" />
        </template>
      </el-table-column>
      <el-table-column label="优惠金额" align="center" prop="discountValue">
        <template slot-scope="scope">
          ¥{{ scope.row.discountValue?.toLocaleString() }}
        </template>
      </el-table-column>
      <el-table-column label="活动状态" align="center" prop="status">
        <template slot-scope="scope">
          <el-tag :type="scope.row.status === 1 ? 'success' : 'info'">
            {{ scope.row.status === 1 ? '上架' : '下架' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="开始时间" align="center" prop="startTime" width="180" />
      <el-table-column label="结束时间" align="center" prop="endTime" width="180" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)" v-hasPermi="['carsale:promotion:edit']">修改</el-button>
          <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)" v-hasPermi="['carsale:promotion:remove']">删除</el-button>
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

    <!-- 添加或修改促销活动对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="600px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="120px">
        <el-form-item label="活动名称" prop="title">
          <el-input v-model="form.title" placeholder="请输入活动名称" />
        </el-form-item>
        <el-form-item label="关联车型ID" prop="vehicleId">
          <el-input-number v-model="form.vehicleId" :min="1" style="width: 100%" />
        </el-form-item>
        <el-form-item label="优惠类型" prop="discountType">
          <el-select v-model="form.discountType" placeholder="请选择优惠类型" style="width: 100%">
            <el-option label="直降" :value="0" />
            <el-option label="赠品" :value="1" />
            <el-option label="置换补贴" :value="2" />
          </el-select>
        </el-form-item>
        <el-form-item label="优惠金额" prop="discountValue">
          <el-input-number v-model="form.discountValue" :min="0" :precision="2" style="width: 100%" />
        </el-form-item>
        <el-form-item label="活动状态" prop="status">
          <el-radio-group v-model="form.status">
            <el-radio :label="0">下架</el-radio>
            <el-radio :label="1">上架</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="有效期">
          <el-date-picker
            v-model="dateRange"
            type="datetimerange"
            range-separator="至"
            start-placeholder="开始时间"
            end-placeholder="结束时间"
            value-format="yyyy-MM-dd HH:mm:ss"
            style="width: 100%"
          />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getAdminPromotionList, getAdminPromotionDetail, addPromotion, updatePromotion, deletePromotion } from '@/api/carsale/promotion'

export default {
  name: 'AdminPromotion',
  dicts: ['carsale_discount_type'],
  data() {
    return {
      loading: false,
      showSearch: true,
      total: 0,
      promotionList: [],
      title: '',
      open: false,
      ids: [],
      single: true,
      multiple: true,
      dateRange: [],
      form: {},
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        title: null,
        status: null
      },
      rules: {
        title: [{ required: true, message: '活动名称不能为空', trigger: 'blur' }],
        vehicleId: [{ required: true, message: '关联车型ID不能为空', trigger: 'blur' }],
        discountType: [{ required: true, message: '优惠类型不能为空', trigger: 'change' }],
        discountValue: [{ required: true, message: '优惠金额不能为空', trigger: 'blur' }],
        status: [{ required: true, message: '活动状态不能为空', trigger: 'change' }]
      }
    }
  },
  created() {
    this.getList()
  },
  methods: {
    getList() {
      this.loading = true
      getAdminPromotionList(this.queryParams).then(response => {
        this.promotionList = response.rows
        this.total = response.total
        this.loading = false
      })
    },
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.id)
      this.single = selection.length !== 1
      this.multiple = !selection.length
    },
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    resetQuery() {
      this.resetForm('queryForm')
      this.handleQuery()
    },
    handleAdd() {
      this.title = '新增促销活动'
      this.open = true
      this.reset()
    },
    handleUpdate(row) {
      this.title = '修改促销活动'
      this.open = true
      this.reset()
      const id = row.id || this.ids[0]
      getAdminPromotionDetail(id).then(response => {
        this.form = response.data
        if (this.form.startTime && this.form.endTime) {
          this.dateRange = [this.form.startTime, this.form.endTime]
        }
      })
    },
    submitForm() {
      this.$refs['form'].validate(valid => {
        if (valid) {
          if (this.dateRange && this.dateRange.length === 2) {
            this.form.startTime = this.dateRange[0]
            this.form.endTime = this.dateRange[1]
          }
          if (this.form.id != null) {
            updatePromotion(this.form).then(() => {
              this.$modal.msgSuccess('修改成功')
              this.open = false
              this.getList()
            })
          } else {
            addPromotion(this.form).then(() => {
              this.$modal.msgSuccess('新增成功')
              this.open = false
              this.getList()
            })
          }
        }
      })
    },
    cancel() {
      this.open = false
      this.reset()
    },
    reset() {
      this.form = {
        id: null,
        title: null,
        vehicleId: null,
        discountType: null,
        discountValue: null,
        status: 1,
        startTime: null,
        endTime: null
      }
      this.dateRange = []
      this.resetForm('form')
    },
    handleDelete(row) {
      const ids = row.id || this.ids
      this.$modal.confirm('是否确认删除促销活动编号为"' + ids + '"的数据项？').then(() => {
        return deletePromotion(ids)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess('删除成功')
      })
    }
  }
}
</script>
