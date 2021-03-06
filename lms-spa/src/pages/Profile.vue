<template>
  <q-page class="q-px-sm q-pt-md">
    <div class="row full-width q-gutter-sm">
      <div class="col-12">
        <span class="text-weight-light text-h5">User profile</span>
        <q-btn
          @click="editMode = !editMode"
          v-show="userId == user.id"
          class="q-ml-sm"
          round
          size="sm"
          flat
          :icon="editMode ? 'mdi-pencil-off' : 'mdi-pencil-plus'"
        >
          <q-tooltip>{{ editMode ? 'Stop editing' : 'Edit information' }}</q-tooltip>
        </q-btn>
      </div>
      <div class="col-12 q-pb-md">
        <q-separator />
      </div>
      <template v-if="userData">
        <div class="col-12">
          <div class="row">
            <div class="col-xs-12 col-md-3 text-center">
              <q-img
                class="image-box q-mb-md"
                :width="$q.screen.sm || $q.screen.xs ? '300px' : '75%'"
                height="300px"
                :src="generatePictureSource(userData.picture)"
              />
            </div>
            <div class="col-xs-12 col-md-6">
              <div class="row q-pr-md q-gutter-sm">
                <template v-if="userId == user.id && editMode">
                  <div
                    class="q-pl-sm"
                    :class="[$q.dark.isActive ? 'hint-text-dark' : 'hint-text']"
                  >Personal information</div>
                  <div class="col-12">
                    <q-input readonly label="Username" dense outlined :value="userData.username" />
                  </div>
                  <div class="col-12">
                    <q-form class="q-gutter-sm" @input="personalInformationChange">
                      <q-input
                        :readonly="userId != user.id"
                        label="Name"
                        dense
                        outlined
                        v-model="userData.name"
                      />
                      <q-input
                        :readonly="userId != user.id"
                        label="Surname"
                        dense
                        outlined
                        v-model="userData.surname"
                      />
                      <q-input
                        :readonly="userId != user.id"
                        label="Email"
                        dense
                        outlined
                        v-model="userData.email"
                      />
                    </q-form>
                  </div>
                  <div class="col-12" v-show="userId == user.id">
                    <q-file
                      accept=".jpg, .png"
                      dense
                      outlined
                      v-model="picture"
                      clearable
                      label="Upload new picture"
                      @input="uploadPicture"
                    >
                      <template v-slot:prepend>
                        <q-icon name="mdi-image" />
                      </template>
                    </q-file>
                  </div>
                  <div
                    class="q-ml-md q-mb-md"
                    :class="[$q.dark.isActive ? 'hint-text-dark' : 'hint-text']"
                  >
                    *
                    <q-icon size="xs" class="q-mr-xs" name="mdi-lock-check" />Your data is automatically saved after a small delay
                  </div>
                </template>
                <template v-else>
                  <div class="col-12">
                    <div style="font-size: 26px;">{{ userData.name + ' ' + userData.surname }}</div>
                    <div class="q-pl-sm" style="font-size: 14px;">Username: {{ userData.username }}</div>
                    <div class="q-pl-sm" style="font-size: 14px;">Email: {{ userData.email }}</div>
                  </div>
                </template>
              </div>
            </div>
          </div>
        </div>
      </template>
    </div>
  </q-page>
</template>

<script>
import { mapActions, mapGetters } from "vuex";
import UserService from "../services/api/user";
import NotificationService from "../services/notification/notifications";
import { debounce } from "debounce";
import { generatePictureSource } from "../helpers/helpers";

export default {
  name: "Settings",
  data() {
    return {
      userId: null,
      userData: null,
      picture: null,
      editMode: false
    };
  },
  created() {
    this.userId = this.$route.params.id;
    this.getUserData(this.userId);
  },
  beforeRouteUpdate(to, from, next) {
    if (to.params.id == this.userId) {
      return;
    }
    this.userId = to.params.id;
    this.getUserData(this.userId);
    next();
  },
  computed: {
    ...mapGetters(["user"])
  },
  methods: {
    ...mapActions(["setUserData"]),
    generatePictureSource,
    getUserData(userId) {
      UserService.getUserDetails(userId).then(({ data }) => {
        this.userData = data;
      });
    },
    personalInformationChange: debounce(function() {
      let user = { ...this.user };
      [user.name, user.surname, user.email] = [
        this.userData.name,
        this.userData.surname,
        this.userData.email
      ];
      let payload = {
        userId: this.user.id,
        name: this.userData.name,
        surname: this.userData.surname,
        email: this.userData.email
      };
      UserService.updatePersonalInformation(payload).then(() => {
        this.setUserData(user);
        NotificationService.showSuccess("Personal info updated!");
      });
    }, 1500),
    blacklistChange: debounce(function() {
      NotificationService.showSuccess("Blacklist updated!");
    }, 1500),
    uploadPicture(file) {
      if (!file) {
        return;
      }
      let formData = new FormData();
      formData.append("picture", file);
      UserService.uploadPicture(this.user.id, formData).then(({ data }) => {
        let user = { ...this.user };
        this.userData.picture = data.payload.picture.data;
        user.picture = data.payload.picture.data;
        this.setUserData(user);
      });
      this.picture = null;
    }
  }
};
</script>

<style lang="sass">
.image-box
  border-radius: 15%
  border: 1px solid #e0dede
</style>