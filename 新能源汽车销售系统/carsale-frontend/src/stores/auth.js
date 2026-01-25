import { defineStore } from 'pinia'
import { login as loginApi, logout as logoutApi, getInfo } from '@/api/auth'
import { getToken, setToken, removeToken } from '@/utils/auth'
import { message } from 'ant-design-vue'

export const useAuthStore = defineStore('auth', {
  state: () => ({
    token: getToken(),
    name: '',
    avatar: '',
    roles: []
  }),

  getters: {
    isLoggedIn: (state) => !!state.token
  },

  actions: {
    // 登录
    async login(loginForm) {
      const { username, password, code, uuid } = loginForm
      try {
        const res = await loginApi(username, password, code, uuid)
        setToken(res.token)
        this.token = res.token
        return Promise.resolve()
      } catch (error) {
        return Promise.reject(error)
      }
    },

    // 获取用户信息
    async getUserInfo() {
      try {
        const res = await getInfo()
        const { user, roles } = res
        this.name = user.userName
        this.avatar = user.avatar || ''
        this.roles = roles
        return Promise.resolve(res)
      } catch (error) {
        return Promise.reject(error)
      }
    },

    // 登出
    async logout() {
      try {
        await logoutApi()
        this.token = ''
        this.name = ''
        this.avatar = ''
        this.roles = []
        removeToken()
        return Promise.resolve()
      } catch (error) {
        // 即使登出接口失败，也清除本地状态
        this.token = ''
        this.name = ''
        this.avatar = ''
        this.roles = []
        removeToken()
        return Promise.resolve()
      }
    },

    // 重置状态
    resetState() {
      this.token = ''
      this.name = ''
      this.avatar = ''
      this.roles = []
      removeToken()
    }
  }
})
