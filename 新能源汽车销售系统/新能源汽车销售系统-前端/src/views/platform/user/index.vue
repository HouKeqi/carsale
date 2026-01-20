<template>
  <div class="app-container">



    <!-- 搜索栏 -->
    <!-- 属性解释   inline:行类表单  showSearch:显示搜索框 -->
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true"  v-show="showSearch" label-width="68px">
      <el-form-item label="用户名称" prop="name">
        <!-- 属性解释   @keyup.enter.native: 回车键 ,按键回车触发事件 -->
        <el-input
          v-model="queryParams.name"
          placeholder="请输入用户名称"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>

      <el-form-item label="手机号码" prop="phone">
        <el-input
          v-model="queryParams.phone"
          placeholder="请输入手机号码"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>


      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>




    <!-- 按钮显示 -->
    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <!-- v-hasPermi属性 判断是否有【mes:project:add】权限 -->
        <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd"
                   v-hasPermi="['platform:user:add']">新增</el-button>
      </el-col>

      <el-col :span="1.5">
        <el-button type="success" plain icon="el-icon-edit" size="mini" :disabled="single"
                   @click="handleUpdate" v-hasPermi="['platform:user:edit']">修改</el-button>
      </el-col>

      <el-col :span="1.5">
        <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple"
                   @click="handleDelete" v-hasPermi="['platform:user:remove']">删除</el-button>
      </el-col>

      <el-col :span="1.5">
        <el-button type="warning" plain icon="el-icon-download" size="mini" @click="handleExport"
                   v-hasPermi="['platform:user:export']">导出</el-button>
      </el-col>

      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>



    <!-- 添加或修改产品建模对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">

        <el-form-item label="用户名称" prop="name">
          <el-input v-model="form.name" placeholder="请输入用户名称" />
        </el-form-item>

        <el-form-item label="用户编号">
          <el-select v-model="form.userId" placeholder="请选择用户编号">
            <el-option
              v-for="item in userIdOptions"
              :key="item.id"
              :label="item.name"
              :value="item.id"
            ></el-option>
          </el-select>
        </el-form-item>

        <el-form-item label="用户名称" prop="name">
          <el-input v-model="form.name" placeholder="请输入用户名称" />
        </el-form-item>

        <el-form-item label="用户名称" prop="name">
          <el-input v-model="form.name" placeholder="请输入用户名称" />
        </el-form-item>

        <el-form-item label="用户名称" prop="name">
          <el-input v-model="form.name" placeholder="请输入用户名称" />
        </el-form-item>

        <el-form-item label="用户名称" prop="name">
          <el-input v-model="form.name" placeholder="请输入用户名称" />
        </el-form-item>


      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>






    <!-- 表格数据显示 -->
    <el-table v-loading="loading" :data="UserList" @selection-change="handleSelectionChange" >
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="用户编号" align="center" prop="userId" />
      <el-table-column label="用户名称" align="center" prop="name" />
      <el-table-column label="身份" align="center" prop="role">
        <!-- 传过来的status是0/1,修改成数据字典中的挂起/正常 -->
        <template slot-scope="scope">
          <!-- options是字典中的数据, 将value中的值与 option数据字典中的value进行对比, 找到对应的label【挂起/正常】, 显示在页面上 -->
          <dict-tag :options="dict.type.platform_user_role" :value="scope.row.role"/>
        </template>
      </el-table-column>
      <el-table-column label="电话号码" align="center" prop="phone" />
      <el-table-column label="学号" align="center" prop="studentId" />
      <el-table-column label="Email" align="center" prop="email" />



      <el-table-column label="操作" align="center" width="160" class-name="small-padding fixed-width">
        <template slot-scope="scope" v-if="scope.row.name !== 'admin'">
          <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)"
                     v-hasPermi="['platform:user:edit']">修改</el-button>

          <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)"
                     v-hasPermi="['platform:user:remove']">删除</el-button>

          <el-dropdown size="mini" @command="(command) => handleCommand(command, scope.row)"
                       v-hasPermi="['platform:user:resetPwd', 'platform:user:edit']">
            <el-button size="mini" type="text" icon="el-icon-d-arrow-right">更多</el-button>
            <el-dropdown-menu slot="dropdown">
              <el-dropdown-item command="handleResetPwd" icon="el-icon-key"
                                v-hasPermi="['platform:user:resetPwd']">重置密码</el-dropdown-item>
              <el-dropdown-item command="handleAuthRole" icon="el-icon-circle-check"
                                v-hasPermi="['platform:user:edit']">分配角色</el-dropdown-item>
            </el-dropdown-menu>
          </el-dropdown>
        </template>
      </el-table-column>

    </el-table>


    <!-- 分页显示，其中@pagination属性: 页面发生变化时, 调用getList方法 -->
    <pagination v-show="total>0" :total="total" :page.sync="queryParams.pageNum"
                :limit.sync="queryParams.pageSize" @pagination="getList"/>

  </div>


</template>


<script>
  import { getUserList } from '@/api/platform/user'
  import Treeselect from '@riophae/vue-treeselect'
  import { getUser } from '@/api/system/user'

  export default {
    components: { Treeselect },
    dicts: ['platform_user_role'],
    data() {
      return{
        // 遮罩层
        loading:true,
        // 表格数据
        UserList: [],
        // 总条数
        total : 0,
        // 对话框标题
        title: "新增平台用户",
        // 是否显示对话框
        open: false,
        // 是否显示搜索框
        showSearch:true,
        // 角色选项
        roleOptions: [],
        // 用户编号下拉框
        userIdOptions: [],
        // 查询参数
        queryParams: {
          pageNum: 1,
          pageSize: 10,
        },
        // 表单验证规则
        rules:{
          name: [
            { required: true, message: "用户名称不能为空", trigger: "blur" }
          ],
          phonenumber: [
            {
              pattern: /^1[3|4|5|6|7|8|9][0-9]\d{8}$/,
              message: "请输入正确的手机号码",
              trigger: "blur"
            }
          ],
          nickName: [
            { required: true, message: "用户昵称不能为空", trigger: "blur" }
          ],
          password: [
            { required: true, message: "用户密码不能为空", trigger: "blur" },
            { min: 5, max: 20, message: '用户密码长度必须介于 5 和 20 之间', trigger: 'blur' },
            { pattern: /^[^<>"'|\\]+$/, message: "不能包含非法字符：< > \" ' \\\ |", trigger: "blur" }
          ],
          email: [
            {
              type: "email",
              message: "请输入正确的邮箱地址",
              trigger: ["blur", "change"]
            }
          ],
        },
        // 表单参数
        form: {

        },

      }
    },

    created() {
      this.getList();
    },


    methods: {
      getList()
      {
        this.loading = true;
        getUserList(this.queryParams).then(res =>
        {

          this.UserList = res.rows;
          console.log(this.UserList);
          this.total = res.total;
          this.loading = false;
        })
      },

      /** 搜索按钮操作 */
      handleQuery() {
        this.queryParams.pageNum = 1;
        this.getList();
      },

      // 多选框选中数据
      handleSelectionChange(selection) {
        this.ids = selection.map(item => item.id);
        this.single = selection.length != 1;
        this.multiple = !selection.length;
      },

      /** 修改按钮操作 */
      handleUpdate(row) {
        this.reset();
        const id = row.id || this.ids;
        getUser(id).then(response => {
          this.form = response.data;
          this.roleOptions = response.roles;
          this.$set(this.form, "roleIds", response.roleIds);
          this.open = true;
          this.title = "修改用户";
          this.form.password = "";
        });
      },

      /** 表单重置 */
      reset() {
        this.form = {
          id: null,
          name: null,
          userId: null,
        };
        this.resetForm("form");
      },

      /** 新增按钮操作 */
      handleAdd() {
        this.reset();
        this.open = true;
        this.title = "添加产品建模";
      },



    }
  }

</script>




<style scoped lang="scss">

</style>
