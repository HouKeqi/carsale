<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="100px">
      <el-form-item label="车型名称" prop="name">
        <el-input
          v-model="queryParams.name"
          placeholder="请输入车型名称"
          clearable
          style="width: 200px"
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="品牌" prop="brand">
        <el-select v-model="queryParams.brand" placeholder="请选择品牌" clearable style="width: 150px">
          <el-option label="Tesla" value="Tesla" />
          <el-option label="BYD" value="BYD" />
          <el-option label="Xiaomi" value="Xiaomi" />
        </el-select>
      </el-form-item>
      <el-form-item label="价格范围" prop="priceRange">
        <el-input-number
          v-model="queryParams.minPrice"
          :min="0"
          :precision="0"
          placeholder="最低价"
          style="width: 120px"
        />
        <span style="margin: 0 8px">-</span>
        <el-input-number
          v-model="queryParams.maxPrice"
          :min="0"
          :precision="0"
          placeholder="最高价"
          style="width: 120px"
        />
      </el-form-item>
      <el-form-item label="续航里程" prop="rangeKm">
        <el-input-number
          v-model="queryParams.minRangeKm"
          :min="0"
          placeholder="最小"
          style="width: 100px"
        />
        <span style="margin: 0 8px">-</span>
        <el-input-number
          v-model="queryParams.maxRangeKm"
          :min="0"
          placeholder="最大"
          style="width: 100px"
        />
        <span style="margin-left: 8px">km</span>
      </el-form-item>
      <el-form-item label="电池类型" prop="batteryType">
        <el-select v-model="queryParams.batteryType" placeholder="请选择" clearable style="width: 150px">
          <el-option label="三元锂电池" :value="0" />
          <el-option label="磷酸铁锂电池" :value="1" />
          <el-option label="其他" :value="2" />
        </el-select>
      </el-form-item>
      <el-form-item label="库存状态" prop="stockStatus">
        <el-select v-model="queryParams.stockStatus" placeholder="请选择" clearable style="width: 120px">
          <el-option label="充足" value="sufficient" />
          <el-option label="预警(≤5)" value="warning" />
          <el-option label="缺货(=0)" value="out" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['carsale:vehicle:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate" v-hasPermi="['carsale:vehicle:edit']">修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete" v-hasPermi="['carsale:vehicle:remove']">删除</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="vehicleList" @selection-change="handleSelectionChange" stripe>
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="车辆编号" align="center" prop="id" width="100" sortable="custom" :sort-orders="['ascending', 'descending']" @sort-change="handleSortChange" />
      <el-table-column label="车型名称" align="center" prop="name" min-width="150" show-overflow-tooltip />
      <el-table-column label="品牌" align="center" prop="brand" width="120" />
      <el-table-column label="指导价" align="center" prop="price" width="130" sortable="custom" :sort-orders="['ascending', 'descending']" @sort-change="handleSortChange">
        <template slot-scope="scope">
          <span style="color: #f56c6c; font-weight: bold">¥{{ scope.row.price?.toLocaleString() }}</span>
        </template>
      </el-table-column>
      <el-table-column label="电池类型" align="center" prop="batteryType" width="120">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.batteryType === 0" type="success" size="small">三元锂电池</el-tag>
          <el-tag v-else-if="scope.row.batteryType === 1" type="warning" size="small">磷酸铁锂电池</el-tag>
          <el-tag v-else-if="scope.row.batteryType === 2" type="info" size="small">其他</el-tag>
          <span v-else>-</span>
        </template>
      </el-table-column>
      <el-table-column label="续航里程" align="center" prop="rangeKm" width="120" sortable="custom" :sort-orders="['ascending', 'descending']" @sort-change="handleSortChange">
        <template slot-scope="scope">
          <span style="color: #409eff">{{ scope.row.rangeKm }}km</span>
        </template>
      </el-table-column>
      <el-table-column label="库存数量" align="center" prop="stock" width="120" sortable="custom" :sort-orders="['ascending', 'descending']" @sort-change="handleSortChange">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.stock === 0" type="danger" size="small">缺货</el-tag>
          <el-tag v-else-if="scope.row.stock <= 5" type="warning" size="small">{{ scope.row.stock }}</el-tag>
          <el-tag v-else type="success" size="small">{{ scope.row.stock }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="上市时间" align="center" prop="launchDate" width="120" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="180" fixed="right">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-view" @click="handleView(scope.row)">查看</el-button>
          <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)" v-hasPermi="['carsale:vehicle:edit']">修改</el-button>
          <el-button size="mini" type="text" icon="el-icon-delete" style="color: #f56c6c" @click="handleDelete(scope.row)" v-hasPermi="['carsale:vehicle:remove']">删除</el-button>
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

    <!-- 添加或修改车辆对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="800px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="120px">
        <el-row>
          <el-col :span="12">
            <el-form-item label="车型名称" prop="name">
              <el-input v-model="form.name" placeholder="请输入车型名称" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="品牌" prop="brand">
              <el-input v-model="form.brand" placeholder="请输入品牌" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="指导价" prop="price">
              <el-input-number v-model="form.price" :min="0" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="电池类型" prop="batteryType">
              <el-select v-model="form.batteryType" placeholder="请选择电池类型" style="width: 100%">
                <el-option label="三元锂电池" :value="0" />
                <el-option label="磷酸铁锂电池" :value="1" />
                <el-option label="其他" :value="2" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="续航里程(km)" prop="rangeKm">
              <el-input-number v-model="form.rangeKm" :min="0" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="库存数量" prop="stock">
              <el-input-number v-model="form.stock" :min="0" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="上市时间" prop="launchDate">
              <el-date-picker
                v-model="form.launchDate"
                type="date"
                placeholder="选择上市时间"
                value-format="yyyy-MM-dd"
                style="width: 100%"
              />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="车辆编号" prop="id" v-if="form.id">
              <el-input v-model="form.id" disabled />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="配置参数" prop="configJson">
          <el-input
            v-model="form.configJson"
            type="textarea"
            :rows="3"
            placeholder='请输入JSON格式，如：{"fast_charge":"0.5h", "ai_level":"L2"}'
          />
          <div style="color: #909399; font-size: 12px; margin-top: 5px;">
            提示：请确保输入的是有效的JSON格式
          </div>
        </el-form-item>
        <el-form-item label="车辆描述" prop="description">
          <el-input v-model="form.description" type="textarea" :rows="4" placeholder="请输入车辆描述信息" maxlength="500" show-word-limit />
        </el-form-item>
        <el-form-item label="车辆图片" prop="imageUrl">
          <image-upload 
            v-model="form.imageUrl" 
            :limit="1" 
            :fileSize="5" 
            :fileType="['png', 'jpg', 'jpeg']"
          />
          <div style="color: #909399; font-size: 12px; margin-top: 5px;">
            支持格式：PNG、JPG、JPEG，大小不超过5MB
          </div>
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
import { getAdminVehicleList, getAdminVehicleDetail, addVehicle, updateVehicle, deleteVehicle } from '@/api/carsale/adminVehicle'
import ImageUpload from '@/components/ImageUpload'

export default {
  name: 'AdminVehicle',
  components: {
    ImageUpload
  },
  data() {
    return {
      loading: false,
      showSearch: true,
      total: 0,
      vehicleList: [],
      title: '',
      open: false,
      ids: [],
      single: true,
      multiple: true,
      form: {},
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        name: null,
        brand: null,
        minPrice: null,
        maxPrice: null,
        minRangeKm: null,
        maxRangeKm: null,
        batteryType: null,
        stockStatus: null,
        orderByColumn: null,
        isAsc: null
      },
      rules: {
        name: [{ required: true, message: '车型名称不能为空', trigger: 'blur' }],
        brand: [{ required: true, message: '品牌不能为空', trigger: 'blur' }],
        price: [{ required: true, message: '指导价不能为空', trigger: 'blur' }],
        batteryType: [{ required: true, message: '电池类型不能为空', trigger: 'change' }],
        rangeKm: [{ required: true, message: '续航里程不能为空', trigger: 'blur' }],
        stock: [{ required: true, message: '库存数量不能为空', trigger: 'blur' }]
      }
    }
  },
  created() {
    this.getList()
  },
  methods: {
    getList() {
      this.loading = true
      // 处理库存状态筛选
      const params = { ...this.queryParams }
      if (params.stockStatus === 'warning') {
        // 库存预警：需要后端支持，这里先过滤前端数据
        // 实际应该在后端处理
      } else if (params.stockStatus === 'out') {
        params.stock = 0
        params.stockStatus = null
      } else if (params.stockStatus === 'sufficient') {
        params.stockStatus = null
        // 充足：库存>5，需要后端支持
      }
      
      getAdminVehicleList(params).then(response => {
        let list = response.rows || []
        // 前端过滤库存状态（如果后端不支持）
        if (this.queryParams.stockStatus === 'warning') {
          list = list.filter(item => item.stock > 0 && item.stock <= 5)
        } else if (this.queryParams.stockStatus === 'sufficient') {
          list = list.filter(item => item.stock > 5)
        }
        this.vehicleList = list
        this.total = list.length
        this.loading = false
      }).catch(() => {
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
      this.queryParams = {
        pageNum: 1,
        pageSize: 10,
        name: null,
        brand: null,
        minPrice: null,
        maxPrice: null,
        minRangeKm: null,
        maxRangeKm: null,
        batteryType: null,
        stockStatus: null,
        orderByColumn: null,
        isAsc: null
      }
      this.handleQuery()
    },
    handleSortChange(column) {
      if (column.prop) {
        this.queryParams.orderByColumn = column.prop === 'id' ? 'id' : column.prop
        this.queryParams.isAsc = column.order === 'ascending' ? 'ASC' : 'DESC'
        this.handleQuery()
      }
    },
    handleView(row) {
      const id = row.id
      getAdminVehicleDetail(id).then(response => {
        const vehicle = response.data
        this.$alert(`
          <div style="text-align: left; line-height: 2;">
            <p><strong>车型名称：</strong>${vehicle.name || '-'}</p>
            <p><strong>品牌：</strong>${vehicle.brand || '-'}</p>
            <p><strong>指导价：</strong>¥${vehicle.price?.toLocaleString() || '-'}</p>
            <p><strong>电池类型：</strong>${vehicle.batteryType === 0 ? '三元锂电池' : vehicle.batteryType === 1 ? '磷酸铁锂电池' : vehicle.batteryType === 2 ? '其他' : '-'}</p>
            <p><strong>续航里程：</strong>${vehicle.rangeKm || '-'}km</p>
            <p><strong>库存数量：</strong>${vehicle.stock || 0}</p>
            <p><strong>上市时间：</strong>${vehicle.launchDate || '-'}</p>
            <p><strong>配置参数：</strong>${vehicle.configJson || '-'}</p>
            <p><strong>车辆描述：</strong>${vehicle.description || '-'}</p>
            ${vehicle.imageUrl ? `<p><strong>车辆图片：</strong><br/><img src="${vehicle.imageUrl}" style="max-width: 300px; margin-top: 10px;" /></p>` : ''}
          </div>
        `, '车辆详细信息', {
          dangerouslyUseHTMLString: true,
          confirmButtonText: '关闭'
        })
      })
    },
    handleAdd() {
      this.title = '新增车辆'
      this.open = true
      this.reset()
    },
    handleUpdate(row) {
      this.title = '修改车辆'
      this.open = true
      this.reset()
      const id = row.id || this.ids[0]
      getAdminVehicleDetail(id).then(response => {
        this.form = response.data
        // 确保imageUrl是字符串格式（ImageUpload组件需要）
        if (this.form.imageUrl && typeof this.form.imageUrl !== 'string') {
          this.form.imageUrl = String(this.form.imageUrl)
        }
      })
    },
    submitForm() {
      this.$refs['form'].validate(valid => {
        if (valid) {
          // 处理图片URL：如果是逗号分隔的字符串，只取第一个
          if (this.form.imageUrl && this.form.imageUrl.includes(',')) {
            this.form.imageUrl = this.form.imageUrl.split(',')[0]
          }
          // 验证配置JSON格式
          if (this.form.configJson && this.form.configJson.trim()) {
            try {
              JSON.parse(this.form.configJson)
            } catch (e) {
              this.$modal.msgError('配置参数格式错误，请输入有效的JSON格式')
              return
            }
          }
          // 验证价格
          if (this.form.price < 0) {
            this.$modal.msgError('价格不能为负数')
            return
          }
          // 验证库存
          if (this.form.stock < 0) {
            this.$modal.msgError('库存数量不能为负数')
            return
          }
          if (this.form.id != null) {
            updateVehicle(this.form).then(() => {
              this.$modal.msgSuccess('修改成功')
              this.open = false
              this.getList()
            }).catch(() => {
              this.$modal.msgError('修改失败，请重试')
            })
          } else {
            addVehicle(this.form).then(() => {
              this.$modal.msgSuccess('新增成功')
              this.open = false
              this.getList()
            }).catch(() => {
              this.$modal.msgError('新增失败，请重试')
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
        name: null,
        brand: null,
        price: null,
        batteryType: null,
        rangeKm: null,
        stock: null,
        launchDate: null,
        configJson: null,
        description: null,
        imageUrl: null
      }
      this.resetForm('form')
    },
    handleDelete(row) {
      const ids = row.id || this.ids
      this.$modal.confirm('是否确认删除车辆编号为"' + ids + '"的数据项？').then(() => {
        return deleteVehicle(ids)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess('删除成功')
      })
    }
  }
}
</script>
