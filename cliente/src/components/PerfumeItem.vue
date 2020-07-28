<template>
    <div class="perfume" @click="openPerf"></div>
</template>

<script>
export default {
    props: ["pid"],
    methods: {
        openPerf() {
            this.$emit("open", this.pid);
        },
    },
};
</script>

<style scoped>
.perfume {
    background-color: rgb(97 59 177 / 50%);
    border-radius: 16px;

    cursor: pointer;
}
</style>
