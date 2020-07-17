<template>
    <div id="app">
        <router-view />
    </div>
</template>

<style lang="scss">
body {
    --main-color-vam: #17a2b8;
}

//MAIN VAM COLOR = NEW MAIN
$vam: "#17a2b8";
$blue: #17a2b8;
$primary: $blue;

// Import Bootstrap and BootstrapVue source SCSS files
@import "../node_modules/bootstrap/scss/bootstrap.scss";
@import "../node_modules/bootstrap-vue/src/index.scss";

$theme-colors: () !default;
$theme-colors: map-merge(
    (
        "primary": $primary,
        "secondary": $secondary,
        "success": $success,
        "info": $info,
        "warning": $warning,
        "danger": $danger,
        "light": $light,
        "dark": $dark,
        "vam": $vam,
    ),
    $theme-colors
);
</style>
