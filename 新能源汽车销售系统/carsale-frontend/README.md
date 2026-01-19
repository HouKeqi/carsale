# 新能源汽车销售系统 - 独立前端

这是一个基于 Vue 3 + Vite 构建的独立前端项目，用于调用 RuoYi 后端接口。

## 技术栈

- Vue 3
- Vite
- Vue Router
- Pinia
- Element Plus
- Axios

## 项目结构

```
carsale-frontend/
├── src/
│   ├── api/              # API 接口
│   │   ├── auth.js        # 认证相关接口
│   │   └── vehicle.js     # 车辆管理接口
│   ├── stores/            # Pinia 状态管理
│   │   └── auth.js        # 认证状态
│   ├── utils/             # 工具函数
│   │   ├── request.js     # Axios 配置
│   │   └── auth.js        # Token 管理
│   ├── views/             # 页面组件
│   │   ├── Login.vue      # 登录页
│   │   └── VehicleList.vue # 车辆列表页
│   ├── router/            # 路由配置
│   │   └── index.js
│   ├── layout/            # 布局组件
│   │   └── index.vue
│   ├── App.vue            # 根组件
│   └── main.js            # 入口文件
├── vite.config.js         # Vite 配置
├── package.json
└── .env.development       # 开发环境变量
```

## 安装依赖

```bash
npm install
```

## 开发

```bash
npm run dev
```

项目将在 `http://localhost:3000` 启动。

## 构建

```bash
npm run build
```

## 配置说明

### 环境变量

在 `.env.development` 文件中配置 API 基础路径：

```
VITE_API_BASE_URL=/dev-api
```

### 代理配置

开发环境通过 Vite 代理解决跨域问题，配置在 `vite.config.js` 中：

```javascript
proxy: {
  '/dev-api': {
    target: 'http://localhost:8080',
    changeOrigin: true,
    rewrite: (path) => path.replace(/^\/dev-api/, '')
  }
}
```

## 接口调用示例

### 车辆列表接口

```javascript
import { getVehicleList } from '@/api/vehicle'

const queryParams = {
  pageNum: 1,
  pageSize: 10,
  name: '',
  brand: ''
}

const res = await getVehicleList(queryParams)
console.log(res.rows) // 车辆列表数据
console.log(res.total) // 总数
```

### 车辆详情接口

```javascript
import { getVehicleDetail } from '@/api/vehicle'

const res = await getVehicleDetail(1)
console.log(res.data) // 车辆详情
```

## 认证

项目使用 Bearer Token 进行认证，Token 存储在 Cookie 中（键名：`Admin-Token`）。

登录后，所有请求会自动在请求头中添加 `Authorization: Bearer {token}`。

## 注意事项

1. 确保后端服务运行在 `http://localhost:8080`
2. 登录接口需要验证码，验证码通过 `/captchaImage` 接口获取
3. 所有接口返回格式为 `{ code, msg, data }`，其中 `code === 200` 表示成功
4. 401 状态码会自动跳转到登录页
