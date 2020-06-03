<template>
  <div>
    <div style="height: 1000px;border:1px solid rgb(180,180,180)" id="citydistri"></div>
    <div style="height: 1000px;border:1px solid rgb(180,180,180)" id="echartss"></div>
    <div style="height: 1000px;border:1px solid rgb(180,180,180)" id="map"></div>
  </div>
</template>

<script>
import echarts from 'echarts';

export default {
  mounted() {
    const myChart = echarts.init(document.getElementById('echartss'));
    const myChart2 = echarts.init(document.getElementById('citydistri'));
    myChart.setOption(this.echarts1_option);
    myChart2.setOption(this.echarts2_option);
  },
  data() {
    return {
      echarts1_option: {
        title: {
          text: 'Percentage Language spoken at home',
          subtext: 'by AURIN.com.au',
          left: 'center',
        },
        tooltip: {
          trigger: 'item',
          formatter: '{a} <br/>{b} : {c} ({d}%)',
        },
        legend: {
          left: 'center',
          top: 'bottom',
          data: ['en', 'fr', 'es', 'it', 'zh', 'de', 'ar', 'ja'],
        },
        toolbox: {
          show: true,
          feature: {
            mark: { show: true },
            dataView: { show: true, readOnly: false },
            magicType: {
              show: true,
              type: ['pie', 'funnel'],
            },
            restore: { show: true },
            saveAsImage: { show: true },
          },
        },
        series: [
          {
            name: 'Area',
            type: 'pie',
            radius: [120, 250],
            center: ['50%', '50%'],
            roseType: 'area',
            data: [
              { value: 200, name: 'en' },
              { value: 5, name: 'es' },
              { value: 15, name: 'fr' },
              { value: 45, name: 'zh' },
              { value: 20, name: 'it' },
              { value: 35, name: 'de' },
              { value: 30, name: 'ar' },
              { value: 20, name: 'ja' },
            ],
          },
        ],
      },
      echarts2_option: {
        tooltip: {
          trigger: 'axis',
          axisPointer: {
            type: 'shadow',
          },
        },
        legend: {
          data: ['en', 'es', 'fr', 'de', 'zh'],
        },
        grid: {
          left: '3%',
          right: '4%',
          bottom: '3%',
          containLabel: true,
        },
        xAxis: {
          type: 'value',
        },
        yAxis: {
          type: 'category',
          data: ['Melbourne', 'Sydney', 'Perth', 'Adelaide', 'Canberra', 'Brisbane', 'Gold Coast'],
        },
        series: [
          {
            name: 'en',
            type: 'bar',
            stack: 'Total',
            label: {
              show: true,
              position: 'insideRight',
            },
            data: [320, 302, 301, 334, 390, 330, 320],
          },
          {
            name: 'es',
            type: 'bar',
            stack: 'Total',
            label: {
              show: true,
              position: 'insideRight',
            },
            data: [120, 132, 101, 134, 90, 230, 210],
          },
          {
            name: 'fr',
            type: 'bar',
            stack: 'Total',
            label: {
              show: true,
              position: 'insideRight',
            },
            data: [220, 182, 191, 234, 290, 330, 310],
          },
          {
            name: 'de',
            type: 'bar',
            stack: 'Total',
            label: {
              show: true,
              position: 'insideRight',
            },
            data: [150, 212, 201, 154, 190, 330, 410],
          },
          {
            name: 'zh',
            type: 'bar',
            stack: 'Total',
            label: {
              show: true,
              position: 'insideRight',
            },
            data: [820, 832, 901, 934, 1290, 1330, 1320],
          },
        ],
      },
    };
  },
};
</script>
