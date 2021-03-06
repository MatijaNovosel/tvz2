
const routes = [
  {
    path: '/',
    component: () => import('layouts/MainLayout.vue'),
    children: [
      {
        path: '',
        name: 'home',
        component: () => import('pages/Index.vue'),
        meta: {
          requiresAuth: true
        }
      },
      {
        path: 'login',
        name: 'login',
        component: () => import('pages/Login.vue')
      },
      {
        path: 'register',
        name: 'register',
        component: () => import('pages/Register.vue')
      },
      {
        path: 'employees',
        name: 'employees',
        component: () => import('pages/Employees.vue'),
        meta: {
          requiresAuth: true
        }
      },
      {
        path: 'test',
        name: 'test',
        component: () => import('pages/Test.vue'),
        meta: {
          requiresAuth: true
        }
      },
      {
        path: 'admin',
        name: 'admin',
        component: () => import('pages/Admin.vue'),
        meta: {
          requiresAuth: true
        }
      },
      {
        path: 'chat',
        name: 'chat',
        component: () => import('pages/Chat.vue'),
        meta: {
          requiresAuth: true
        }
      },
      {
        path: 'courses',
        name: 'courses',
        component: () => import('pages/Course/CourseList.vue'),
        meta: {
          requiresAuth: true
        }
      },
      {
        path: 'course/:id',
        name: 'course-details',
        component: () => import('pages/Course/CourseDetails.vue'),
        children: [
          { path: 'home', name: 'course-details-home', component: () => import('pages/Course/CourseDetailsHome.vue') },
          { path: 'notifications', name: 'course-details-notifications', component: () => import('pages/Course/CourseDetailsNotifications.vue') },
          { path: 'participants', name: 'course-details-participants', component: () => import('pages/Course/CourseDetailsParticipants.vue') },
          { path: 'exams', name: 'course-details-exams', component: () => import('pages/Course/CourseDetailsExams.vue') },
          { path: 'tasks', name: 'course-details-tasks', component: () => import('pages/Course/CourseDetailsTasks.vue') },
          { path: 'discussion', name: 'course-details-discussion', component: () => import('pages/Course/CourseDetailsDiscussion.vue') },
          { path: 'files', name: 'course-details-files', component: () => import('pages/Course/CourseDetailsFiles.vue') },
          { path: 'grades', name: 'course-details-grades', component: () => import('pages/Course/CourseDetailsGrades.vue') }
        ],
        meta: {
          requiresAuth: true
        }
      },
      {
        path: 'exams',
        name: 'exams',
        component: () => import('pages/Exams.vue'),
        meta: {
          requiresAuth: true
        }
      },
      {
        path: 'exams/:id',
        name: 'exam-details',
        component: () => import('pages/ExamDetails.vue'),
        meta: {
          requiresAuth: true
        }
      },
      {
        path: 'exam-preview/:id',
        name: 'exam-preview',
        component: () => import('pages/ExamPreview.vue'),
        meta: {
          requiresAuth: true
        }
      },
      {
        path: 'profile/:id',
        name: 'profile',
        component: () => import('pages/Profile.vue'),
        meta: {
          requiresAuth: true
        }
      },
      {
        path: 'exam-edit/:id',
        name: 'exam-edit',
        component: () => import('pages/ExamEdit.vue'),
        meta: {
          requiresAuth: true
        }
      }
    ]
  }
]

if (process.env.MODE !== 'ssr') {
  routes.push({
    path: '*',
    component: () => import('pages/Error404.vue')
  })
}

export default routes
