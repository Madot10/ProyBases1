<template>
    <b-container fluid class="p-0">
        <b-row no-gutters>
            <b-col cols="2">
                <sidebar></sidebar>
            </b-col>
            <b-col cols="10">
                <router-view></router-view>
            </b-col>
        </b-row>
    </b-container>
</template>

<script>
import Sidebar from "../components/Sidebar";

export default {
    components: {
        Sidebar,
    },
    data() {
        return {};
    },
};
</script>

<style>
body {
    background-color: #e5e5e5;
}
</style>
