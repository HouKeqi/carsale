<template>
  <div class="app-container">
    <el-card>
      <el-tabs v-model="activeTab">
        <el-tab-pane label="个人信息" name="info">
          <el-form ref="form" :model="form" :rules="rules" label-width="120px" style="max-width: 600px">
            <el-form-item label="用户账号" prop="userName">
              <el-input v-model="form.userName" disabled />
            </el-form-item>
            <el-form-item label="用户昵称" prop="nickName">
              <el-input v-model="form.nickName" />
            </el-form-item>
            <el-form-item label="真实姓名" prop="realName">
              <el-input v-model="form.realName" />
            </el-form-item>
            <el-form-item label="手机号码" prop="phonenumber">
              <el-input v-model="form.phonenumber" />
            </el-form-item>
            <el-form-item label="身份证号" prop="idCard">
              <el-input v-model="form.idCard" />
            </el-form-item>
            <el-form-item label="地址" prop="address">
              <el-input v-model="form.address" type="textarea" :rows="3" />
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="submitForm">保存</el-button>
              <el-button @click="reset">重置</el-button>
            </el-form-item>
          </el-form>
        </el-tab-pane>
        <el-tab-pane label="我的订单" name="orders">
          <el-table :data="orderList" v-loading="orderLoading">
            <el-table-column label="订单编号" prop="id" width="180" />
            <el-table-column label="车型ID" prop="vehicleId" width="100" />
            <el-table-column label="订单状态" prop="status" width="100">
              <template slot-scope="scope">
                <dict-tag :options="dict.type.carsale_order_status" :value="scope.row.status" />
              </template>
            </el-table-column>
            <el-table-column label="成交金额" prop="amount" width="120">
              <template slot-scope="scope">
                ¥{{ scope.row.amount?.toLocaleString() }}
              </template>
            </el-table-column>
            <el-table-column label="下单时间" prop="create_Time" width="180">
              <template slot-scope="scope">
                <span>{{ parseTime(scope.row.create_Time) }}</span>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="150">
              <template slot-scope="scope">
                <el-button size="mini" type="text" @click="handleOrderDetail(scope.row.id)">查看详情</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>
        <el-tab-pane label="我的评价" name="evaluations">
          <el-table :data="evaluationList" v-loading="evalLoading">
            <el-table-column label="订单编号" prop="orderId" width="180" />
            <el-table-column label="评分" width="150">
              <template slot-scope="scope">
                <el-rate v-model="scope.row.score" disabled show-score text-color="#ff9900" />
              </template>
            </el-table-column>
            <el-table-column label="评价内容" prop="comment" />
            <el-table-column label="评价时间" prop="create_Time" width="180">
              <template slot-scope="scope">
                <span>{{ parseTime(scope.row.create_Time) }}</span>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>
      </el-tabs>
    </el-card>
  </div>
</template>

<script>
import { getUserProfile, updateUserProfile } from '@/api/system/user'
import { getMyOrderList } from '@/api/carsale/order'
import { getMyEvaluationList } from '@/api/carsale/evaluation'
import { parseTime } from '@/utils/ruoyi'

export default {
  name: 'UserProfile',
  dicts: ['carsale_order_status'],
  data() {
    return {
      activeTab: 'info',
      form: {},
      orderList: [],
      orderLoading: false,
      evaluationList: [],
      evalLoading: false,
      rules: {
        nickName: [{ required: true, message: '用户昵称不能为空', trigger: 'blur' }],
        phonenumber: [
          { required: true, message: '手机号码不能为空', trigger: 'blur' },
          { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号码', trigger: 'blur' }
        ]
      }
    }
  },
  created() {
    this.getUserInfo()
    this.getOrderList()
    this.getEvaluationList()
  },
  methods: {
    getUserInfo() {
      getUserProfile().then(response => {
        this.form = response.data
      })
    },
    getOrderList() {
      this.orderLoading = true
      getMyOrderList({ pageNum: 1, pageSize: 10 }).then(response => {
        this.orderList = response.rows
        this.orderLoading = false
      })
    },
    getEvaluationList() {
      this.evalLoading = true
      getMyEvaluationList({ pageNum: 1, pageSize: 10 }).then(response => {
        this.evaluationList = response.rows
        this.evalLoading = false
      })
    },
    submitForm() {
      this.$refs['form'].validate(valid => {
        if (valid) {
          updateUserProfile(this.form).then(() => {
            this.$modal.msgSuccess('修改成功')
            this.getUserInfo()
          })
        }
      })
    },
    reset() {
      this.getUserInfo()
    },
    handleOrderDetail(id) {
      this.$router.push({ path: '/carsale/order/detail', query: { id: id } })
    }
  }
}
</script>
