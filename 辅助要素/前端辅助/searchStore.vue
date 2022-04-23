<template>
  <view class="section-wrapper">
    <view class="section-content" @click="onClick">
      <image class="icon" src="http://hh-oss-picture.miyapay.com/box/acca8faee2ee789b3132fa4d6b54dfd5.png"></image>
      <input :disabled="disabled" :focus="!disabled" class="input" :value="keywords" type="text" :placeholder="placeholder" @input="onChange" @blur="onBlur" />
      <image v-if="!disabled && keywords" class="close-icon" src="http://hh-oss-picture.miyapay.com/box/1604f89e9dfc6ba3e67462b685562ae4.png" @click="onCancel"></image>
    </view>
    <text v-if="!disabled && showCancel" class="btn-cancel" @click="onbackPage">取消</text>
  </view>
</template>

<script>
export default {
  name: '',
  props: {
    keywords: {
      type: String,
      default: ''
    },
    disabled: {
      type: Boolean,
      default: false
    },
    placeholder: {
      type: String,
      default: '输入门店名称或地址搜索'
    },
    showCancel: {
      type: Boolean,
      default: true
    }
  },
  data() {
    return {}
  },
  computed: {
    buryExtension() {
      return {
        forbidden: true
      }
    }
  },
  methods: {
    onChange(e) {
      this.$emit('onChange', e.detail.value)
    },
    onBlur(e) {
      this.$emit('onBlur', e.detail.value)
    },
    onCancel(e) {
      this.$emit('onCancel')
    },
    onClick(e) {
      this.$emit('onClick')
    },
    onbackPage(e) {
      this.$emit('onbackPage')
    }
  }
}
</script>

<style lang="scss" scoped>
.section-wrapper {
  height: 100rpx;
  width: 100%;
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  position: relative;
  z-index: 1;

  .section-content {
    display: flex;
    flex: 1;
    padding: 0 76rpx 0 76rpx;
    align-items: center;
    justify-content: center;
    position: relative;
    // background-color: #ffffff;
    border-radius: 16rpx;
    height: 72rpx;
    background: #f8f8f8;
    border-radius: 100px;

    .icon {
      width: 30rpx;
      height: 30rpx;
      position: absolute;
      left: 27rpx;
      top: 22rpx;
    }
    .input {
      height: 100%;
      width: 100%;
      text-align: left;
      color: #333330;
      font-size: 26rpx;
      display: inline-block;
      outline: none;
      padding: 15rpx 0;
      background-color: transparent;
    }
    .close-icon {
      width: 30rpx;
      height: 30rpx;
      position: absolute;
      right: 26rpx;
      top: 23rpx;
    }
  }

  .btn-cancel {
    color: #ff7700;
    font-size: 28rpx;
    padding: 32rpx;
  }
}
</style>
