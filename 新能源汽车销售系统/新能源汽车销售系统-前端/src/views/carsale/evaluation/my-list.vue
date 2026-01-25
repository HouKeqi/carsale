<template>
  <div class="app-container">
    <el-table v-loading="loading" :data="evaluationList">
      <el-table-column label="订单编号" prop="orderId" width="180" />
      <el-table-column label="评分" width="150">
        <template slot-scope="scope">
          <el-rate v-model="scope.row.score" disabled show-score text-color="#ff9900" />
        </template>
      </el-table-column>
      <el-table-column label="评价内容" prop="comment" />
      <el-table-column label="图片" width="200">
        <template slot-scope="scope">
          <el-image
            v-if="scope.row.images"
            v-for="(img, index) in getImageList(scope.row.images)"
            :key="index"
            :src="img"
            style="width: 60px; height: 60px; margin-right: 5px"
            :preview-src-list="getImageList(scope.row.images)"
          />
        </template>
      </el-table-column>
      <el-table-column label="评价时间" prop="create_Time" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.create_Time) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="100" align="center">
        <template slot-scope="scope">
          <el-button size="mini" type="text" style="color: #f56c6c" @click="handleDelete(scope.row.id)">删除</el-button>
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
import { getMyEvaluationList, deleteEvaluation } from '@/api/carsale/evaluation'
import { parseTime } from '@/utils/ruoyi'

export default {
  name: 'MyEvaluationList',
  data() {
    return {
      loading: false,
      total: 0,
      evaluationList: [],
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
      getMyEvaluationList(this.queryParams).then(response => {
        this.evaluationList = response.rows
        this.total = response.total
        this.loading = false
      })
    },
    getImageList(images) {
      if (!images) return []
      try {
        return JSON.parse(images)
      } catch (e) {
        return images.split(',').filter(img => img)
      }
    },
    handleDelete(id) {
      this.$modal.confirm('确认删除该评价？').then(() => {
        return deleteEvaluation(id)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess('删除成功')
      })
    }
  }
}
</script>
