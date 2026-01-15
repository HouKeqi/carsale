<template>
  <div>
    <h2>用户购车列表</h2>
  </div>
</template>

<script>
import { getCarOrderList } from "@/api/carsale/carOrder";
export default {
  created() {
    this.getList();
  },
  methods: {
    getList() {
      getCarOrderList().then( body => {
        console.log(body);
      })
    },
  },
}
</script>
