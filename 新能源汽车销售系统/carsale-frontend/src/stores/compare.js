import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useCompareStore = defineStore('compare', () => {
  const compareList = ref([])
  const maxCompareCount = 3

  // 从 localStorage 加载
  const loadFromStorage = () => {
    try {
      const stored = localStorage.getItem('vehicle_compare_list')
      if (stored) {
        compareList.value = JSON.parse(stored)
      }
    } catch (error) {
      console.error('加载对比列表失败', error)
    }
  }

  // 保存到 localStorage
  const saveToStorage = () => {
    try {
      localStorage.setItem('vehicle_compare_list', JSON.stringify(compareList.value))
    } catch (error) {
      console.error('保存对比列表失败', error)
    }
  }

  // 添加车辆到对比
  const addVehicle = (vehicle, replaceIndex = null) => {
    // 检查是否已存在
    if (compareList.value.find(v => v.id === vehicle.id)) {
      return { success: false, message: '该车型已在对比列表中' }
    }
    
    // 如果指定了替换索引，则替换
    if (replaceIndex !== null && replaceIndex >= 0 && replaceIndex < compareList.value.length) {
      compareList.value[replaceIndex] = vehicle
      saveToStorage()
      return { success: true, message: '已替换对比车型' }
    }
    
    // 检查是否超过最大数量
    if (compareList.value.length >= maxCompareCount) {
      return { 
        success: false, 
        message: `最多只能对比${maxCompareCount}款车型`,
        needReplace: true,
        currentList: [...compareList.value]
      }
    }
    
    compareList.value.push(vehicle)
    saveToStorage()
    return { success: true, message: '已添加到对比列表' }
  }

  // 从对比中移除车辆
  const removeVehicle = (vehicleId) => {
    const index = compareList.value.findIndex(v => v.id === vehicleId)
    if (index > -1) {
      compareList.value.splice(index, 1)
      saveToStorage()
      return { success: true, message: '已从对比列表移除' }
    }
    return { success: false, message: '未找到该车型' }
  }

  // 清空对比列表
  const clearCompare = () => {
    compareList.value = []
    saveToStorage()
  }

  // 检查车辆是否在对比列表中
  const isInCompare = (vehicleId) => {
    return compareList.value.some(v => v.id === vehicleId)
  }

  // 初始化时加载
  loadFromStorage()

  // 替换车辆
  const replaceVehicle = (vehicle, oldVehicleId) => {
    const index = compareList.value.findIndex(v => v.id === oldVehicleId)
    if (index > -1) {
      return addVehicle(vehicle, index)
    }
    return { success: false, message: '未找到要替换的车型' }
  }

  return {
    compareList,
    maxCompareCount,
    addVehicle,
    removeVehicle,
    clearCompare,
    isInCompare,
    loadFromStorage,
    replaceVehicle
  }
})
