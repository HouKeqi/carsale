# 快速启动指南

## 1. 安装依赖

```bash
cd carsale-frontend
npm install
```

## 2. 配置环境变量

创建 `.env.development` 文件（如果不存在）：

```env
VITE_API_BASE_URL=/dev-api
```

或者直接在 `vite.config.js` 中修改代理配置。

## 3. 启动开发服务器

```bash
npm run dev
```

项目将在 `http://localhost:3000` 启动。

## 4. 确保后端服务运行

确保 RuoYi 后端服务运行在 `http://localhost:8080`。

## 5. 登录

- 默认用户名：`admin`
- 默认密码：`admin123`
- 需要输入验证码（点击验证码图片可刷新）

## 6. 访问车辆管理

登录成功后，会自动跳转到车辆管理页面，可以查看和操作车辆信息。

## 接口调用示例

### 在组件中调用车辆接口

```vue
<script setup>
import { ref, onMounted } from 'vue'
import { getVehicleList } from '@/api/vehicle'

const vehicleList = ref([])

const loadData = async () => {
  const res = await getVehicleList({
    pageNum: 1,
    pageSize: 10
  })
  vehicleList.value = res.rows || []
}

onMounted(() => {
  loadData()
})
</script>
```

## 常见问题

### 1. 跨域问题

开发环境已通过 Vite 代理解决，确保 `vite.config.js` 中的代理配置正确。

### 2. 401 未授权

- 检查 Token 是否正确存储在 Cookie 中
- 确认后端接口需要认证
- 尝试重新登录

### 3. 接口调用失败

- 检查后端服务是否运行在 `http://localhost:8080`
- 检查网络请求的 URL 是否正确
- 查看浏览器控制台的错误信息
