/*
 * Copyright (c) 2020.
 * Group 49, Melbourne
 * Simon Cozens 1071589
 * Solmaz Maabi 871603
 * Wenkang Dang 1009151
 */
import Vue from 'vue';
import echarts from 'echarts';
import App from './App.vue';
import router from './router';
import store from './store';
import db from './lib/db';

Vue.prototype.$echarts = echarts;
Vue.config.productionTip = false;
Vue.prototype.$db = db;

new Vue({
  router,
  store,
  render: (h) => h(App),
}).$mount('#app');
