import { createApp } from 'vue'
import { createPinia } from 'pinia'
import Antd from 'ant-design-vue'
import 'ant-design-vue/dist/reset.css'
import dayjs from 'dayjs'
import 'dayjs/locale/zh-cn'
import router from './router'
import App from './App.vue'
import './styles/global.scss'
import { initWebSocket } from './plugins/websocket'

dayjs.locale('zh-cn')

const app = createApp(App)
const pinia = createPinia()

app.use(pinia)
app.use(router)
app.use(Antd)

app.mount('#app')

// 初始化 WebSocket
initWebSocket()
