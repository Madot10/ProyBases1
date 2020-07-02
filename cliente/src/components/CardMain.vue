<template>
    <b-container fluid class="view-container">
        <div class="page-header">
            <h2><slot name="title"></slot></h2>
        </div>
        <div class="content-card px-4 py-3">
            <slot name="content"></slot>
        </div>
    </b-container>
</template>

<script>
export default {};
</script>

<style>
.view-container {
    height: 100%;
}

.content-card {
    min-height: 90%;
    background-color: white;
    border-radius: 10px;
}
.page-header h2 {
    text-transform: uppercase;
}
</style>
