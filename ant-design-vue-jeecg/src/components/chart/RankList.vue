<template>
  <div class="rank">

    <h4 class="title"><a-space><a-icon :type="icon" theme="filled" style="color: #1a53ba"></a-icon>{{ title }}</a-space></h4>
    <ul class="list" :style="{height:height?`${height}px`:'auto',overflow:'auto'}">
      <li :key="index" v-for="(item, index) in list">
        <span :class="index < 3 ? 'active' : null">{{ index + 1 }}</span>
        <span>{{ item.name }}</span>
        <span>{{ item.total }}</span>
      </li>
    </ul>
  </div>
</template>

<script>
  export default {
    name: "RankList",
    // ['title', 'list']
    props: {
      icon: {
        type: String,
        default: ''
      },
      title: {
        type: String,
        default: ''
      },
      list: {
        type: Array,
        default: null
      },
      height: {
        type: Number,
        default: null
      }
    }
  }
</script>

<style lang="less" scoped>

  .rank {
    padding: 0 12px 16px 12px;

    .list {
      margin: 5px 0 0;
      padding: 0;
      list-style: none;

      li {
        margin-top: 6px;

        span {
          color: #606266;
          font-size: 14px;
          line-height: 22px;

          &:first-child {
            background-color: #f5f5f5;
            border-radius: 20px;
            display: inline-block;
            font-size: 12px;
            font-weight: 600;
            margin-right: 24px;
            height: 20px;
            line-height: 20px;
            width: 20px;
            text-align: center;
          }
          &.active {
            background-color: #314659;
            color: #fff;
          }
          &:last-child {
            float: right;
          }
        }
      }
    }
  }

  .mobile .rank {
    padding: 0 12px 12px 12px;
  }

</style>