<template>
  <q-page>
    <template v-for="content in sidebarContents">
      <file-cabinet :key="content.id" :content="content" />
    </template>
    <div class="row text-center justify-center q-my-md">
      <div class="col-3">
        <q-input v-model="notification" :label="$i18n.t('enterNewNotification')"></q-input>
      </div>
      <div class="col-1 flex flex-center">
        <q-btn size="md" dense color="primary" @click="sendNotification">{{ $i18n.t('send') }}</q-btn>
      </div>
    </div>
  </q-page>
</template>

<script>
import FileCabinet from "../components/file-cabinet";
import CourseService from "../services/api/course";

export default {
  name: "Test",
  components: {
    "file-cabinet": FileCabinet
  },
  created() {
    CourseService.getCourseSidebar(147).then(({ data }) => {
      this.sidebarContents = data;
    });
  },
  data() {
    return {
      sidebarContents: null
    };
  }
};
</script>

<style scoped lang="sass">
.my-card
  width: 100%
  max-width: 350px
  margin: 5px
</style>