<template>
  <div>
    <div class="row q-mb-md">
      <div class="col-12">
        <div class="q-my-sm" :class="[$q.dark.isActive ? 'hint-text-dark' : 'hint-text']">
          *
          <q-icon size="xs" class="q-mr-xs" name="mdi-mouse" />Right click on cards (or long tap on phones) for more options
        </div>
      </div>
    </div>
    <div class="row" v-if="hasCoursePrivileges(courseId, Privileges.IsInvolvedWithCourse)">
      <div class="col-12">
        <span style="font-size: 12px;">Unfinished exams</span>
      </div>
      <div class="col-12 q-py-sm">
        <q-separator />
      </div>
      <div class="col-12 q-pb-md">
        <div class="row q-col-gutter-sm">
          <template v-if="unfinishedExams && unfinishedExams.length != 0">
            <div class="col-xs-6 col-md-4" :key="i" v-for="(unfinishedExam, i) in unfinishedExams">
              <q-card class="border-box-dark">
                <q-menu touch-position context-menu>
                  <q-list
                    :class="`${$q.dark.isActive ? 'border-dark' : 'border-light'}`"
                    dense
                    separator
                    style="min-width: 100px; border-radius: 6px;"
                  >
                    <q-item
                      @click="$router.push({ name: 'exam-edit', params: { id: unfinishedExam.id } })"
                      clickable
                      v-close-popup
                    >
                      <q-item-section>View</q-item-section>
                    </q-item>
                    <q-item
                      @click="deleteUnfinishedExam(unfinishedExam.id)"
                      clickable
                      v-close-popup
                    >
                      <q-item-section>Delete</q-item-section>
                    </q-item>
                  </q-list>
                </q-menu>
                <q-card-section
                  class="q-py-sm text-center text-subtitle2"
                >Unfinished exam (ID {{ unfinishedExam.id }})</q-card-section>
              </q-card>
            </div>
          </template>
          <div v-else>
            <span>None found!</span>
          </div>
        </div>
      </div>
      <div class="col-12">
        <span style="font-size: 12px;">Created exams</span>
      </div>
      <div class="col-12 q-py-sm">
        <q-separator />
      </div>
      <div class="col-12 q-pb-md">
        <div class="row q-col-gutter-sm">
          <template v-if="finishedExams && finishedExams.length != 0">
            <div class="col-xs-6 col-md-4" :key="i" v-for="(finishedExam, i) in finishedExams">
              <q-card class="border-box-dark">
                <q-menu touch-position context-menu>
                  <q-list
                    :class="`${$q.dark.isActive ? 'border-dark' : 'border-light'}`"
                    dense
                    separator
                    style="min-width: 100px; border-radius: 6px;"
                  >
                    <q-item clickable v-close-popup>
                      <q-item-section>View grades</q-item-section>
                    </q-item>
                    <q-item clickable v-close-popup>
                      <q-item-section @click="deleteFinishedExam(finishedExam.id)">Delete</q-item-section>
                    </q-item>
                    <q-item
                      @click="enableExamSolving(finishedExam.id)"
                      clickable
                      v-close-popup
                      v-if="!finishedExam.enabled"
                    >
                      <q-item-section>Enable solving</q-item-section>
                    </q-item>
                    <q-item
                      clickable
                      v-close-popup
                      @click="$router.push({ name: 'exam-preview', params: { id: finishedExam.id } })"
                    >
                      <q-item-section>Preview</q-item-section>
                    </q-item>
                  </q-list>
                </q-menu>
                <q-card-section
                  class="q-py-sm text-center text-subtitle2"
                >Exam (ID {{ finishedExam.id }})</q-card-section>
                <q-separator />
                <q-card-section class="q-py-sm">
                  <span class="text-subtitle2">Name:</span>
                  <span class="q-ml-sm">{{ finishedExam.name }}</span>
                </q-card-section>
                <q-separator />
                <q-card-section class="q-py-sm">
                  <q-icon
                    size="xs"
                    :color="finishedExam.enabled ? 'green' : 'red'"
                    class="q-mr-md"
                    :name="finishedExam.enabled ? 'mdi-check' : 'mdi-close-thick'"
                  />
                  <span
                    class="text-subtitle2"
                  >{{ finishedExam.enabled ? 'Enabled' : 'Not enabled' }}</span>
                </q-card-section>
              </q-card>
            </div>
          </template>
          <div v-else>
            <span>None found!</span>
          </div>
        </div>
      </div>
    </div>
    <div v-else class="row">
      <div class="col-12">
        <span style="font-size: 12px;">Available exams</span>
      </div>
      <div class="col-12 q-py-sm">
        <q-separator />
      </div>
      <div class="col-12 q-pb-md">
        <div class="row q-col-gutter-sm">
          <template v-if="availableExams && availableExams.length != 0">
            <div class="col-xs-6 col-md-4" :key="i" v-for="(availableExam, i) in availableExams">
              <q-card class="border-box-dark">
                <q-menu touch-position context-menu>
                  <q-list
                    :class="`${$q.dark.isActive ? 'border-dark' : 'border-light'}`"
                    dense
                    separator
                    style="min-width: 100px; border-radius: 6px;"
                  >
                    <q-item clickable v-close-popup @click="startAttempt(availableExam.id)">
                      <q-item-section>Start attempt</q-item-section>
                    </q-item>
                  </q-list>
                </q-menu>
                <q-card-section
                  class="q-py-sm text-center text-subtitle2"
                >Exam (ID {{ availableExam.id }})</q-card-section>
                <q-separator />
                <q-card-section class="q-py-sm">
                  <span class="text-subtitle2">Name:</span>
                  <span class="q-ml-sm">{{ availableExam.name }}</span>
                </q-card-section>
              </q-card>
            </div>
          </template>
          <div v-else>
            <span>None found!</span>
          </div>
        </div>
      </div>
      <div class="col-12">
        <span style="font-size: 12px;">Started exams</span>
      </div>
      <div class="col-12 q-py-sm">
        <q-separator />
      </div>
      <div class="col-12 q-pb-md">
        <div class="row q-col-gutter-sm">
          <template v-if="examsInProgress && examsInProgress.length != 0">
            <div class="col-xs-6 col-md-4" :key="i" v-for="(examInProgress, i) in examsInProgress">
              <q-card class="border-box-dark">
                <q-menu touch-position context-menu>
                  <q-list
                    :class="`${$q.dark.isActive ? 'border-dark' : 'border-light'}`"
                    dense
                    separator
                    style="min-width: 100px; border-radius: 6px;"
                  >
                    <q-item
                      clickable
                      v-close-popup
                      v-if="!examInProgress.expired"
                      @click="$router.push({ name: 'exam-details', params: { id: examInProgress.id }})"
                    >
                      <q-item-section>Continue attempt</q-item-section>
                    </q-item>
                    <q-item
                      clickable
                      v-close-popup
                      @click="$router.push({ name: 'course-details-grades', params: { id: courseId }})"
                    >
                      <q-item-section>View grade</q-item-section>
                    </q-item>
                  </q-list>
                </q-menu>
                <q-card-section
                  class="q-py-sm text-center text-subtitle2"
                >Exam (ID {{ examInProgress.id }})</q-card-section>
                <q-separator />
                <q-card-section class="q-py-none q-pt-md">
                  <span class="text-subtitle2">Name:</span>
                  <span class="q-ml-sm">{{ examInProgress.name }}</span>
                </q-card-section>
                <q-card-section class="q-py-none">
                  <span class="text-subtitle2">Time left:</span>
                  <span
                    class="q-ml-sm"
                    :class="examInProgress.expired ? 'text-red-6' : ''"
                  >{{ examInProgress.expired ? 'Expired' : examInProgress.startedAt }}</span>
                </q-card-section>
                <q-card-section class="q-pt-none q-pb-md">
                  <span class="text-subtitle2">Status:</span>
                  <span
                    class="q-ml-sm text-green-4"
                  >{{ examInProgress.terminated || examInProgress.expired ? 'Terminated' : 'In progress' }}</span>
                </q-card-section>
              </q-card>
            </div>
          </template>
          <div v-else>
            <span>None found!</span>
          </div>
        </div>
      </div>
    </div>
    <q-page-sticky
      position="bottom-right"
      :offset="[18, 18]"
      v-if="hasCoursePrivileges(courseId, Privileges.CanManageCourse, Privileges.CanManageExams, Privileges.CanCreateExams) 
      && hasCoursePrivileges(courseId, Privileges.IsInvolvedWithCourse)"
    >
      <q-fab direction="left" :color="!$q.dark.isActive ? 'primary' : 'grey-8'" fab icon="add">
        <q-fab-action
          icon="mdi-email-plus"
          :color="!$q.dark.isActive ? 'primary' : 'grey-8'"
          label="New exam"
          @click="createNewExam"
        />
      </q-fab>
    </q-page-sticky>
  </div>
</template>

<script>
import ExamService from "../../services/api/exam";
import UserMixin from "../../mixins/userMixin";

export default {
  name: "CourseDetailsExams",
  mixins: [UserMixin],
  methods: {
    startAttempt(id) {
      let payload = {
        examId: id,
        userId: this.user.id
      };
      ExamService.startAttempt(payload, this.courseId).then(({ data }) => {
        this.$router.push({
          name: "exam-details",
          params: { id: data.payload }
        });
      });
    },
    deleteUnfinishedExam(id) {
      ExamService.deleteUnfinishedExam(id).then(() => {
        this.getUnfinishedExams();
      });
    },
    deleteFinishedExam(id) {
      ExamService.deleteFinishedExam(id).then(() => {
        this.getFinishedExams();
      });
    },
    enableExamSolving(id) {
      ExamService.enableExamSolving(id, this.courseId).then(() => {
        this.getFinishedExams();
      });
    },
    getUnfinishedExams() {
      ExamService.getUnfinishedExams(this.user.id, this.courseId).then(
        ({ data }) => {
          this.unfinishedExams = data;
        }
      );
    },
    getFinishedExams() {
      ExamService.getFinishedExams(this.user.id, this.courseId).then(
        ({ data }) => {
          this.finishedExams = data;
        }
      );
    },
    getFinishedExamsForUser() {
      ExamService.getAvailableExams(this.courseId, this.user.id).then(
        ({ data }) => {
          this.availableExams = data;
        }
      );
    },
    getExamsInProgress() {
      ExamService.getExamsInProgress(this.courseId, this.user.id).then(
        ({ data }) => {
          this.examsInProgress = data;
        }
      );
    },
    createNewExam() {
      // Create new exam instance, get the id and send it as a parameter to route
      ExamService.createExam({
        courseId: this.courseId,
        createdById: this.user.id
      }).then(({ data }) => {
        this.$router.push({ name: "exam-edit", params: { id: data.payload } });
      });
    }
  },
  created() {
    this.courseId = this.$route.params.id;
    if (
      this.hasCoursePrivileges(
        this.courseId,
        this.Privileges.IsInvolvedWithCourse
      )
    ) {
      this.getUnfinishedExams();
      this.getFinishedExams();
    } else {
      this.getFinishedExamsForUser();
      this.getExamsInProgress();
    }
  },
  data() {
    return {
      courseId: null,
      unfinishedExams: null,
      finishedExams: null,
      availableExams: null,
      examsInProgress: null
    };
  }
};
</script>

<style lang="sass">
.q-btn--fab .q-btn__wrapper
  padding: 10px
  min-height: 12px
  min-width: 12px
</style>