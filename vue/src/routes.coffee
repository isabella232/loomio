import DashboardPage from './components/dashboard/page.vue'
import InboxPage from './components/inbox/page.vue'
import ExplorePage from './components/explore/page.vue'
import ThreadPage from './components/thread/page.vue'
import StrandPage from './components/strand/page.vue'
import ProfilePage from './components/profile/page.vue'
import PollPage from './components/poll/page.vue'
import PollFormPage from './components/poll/form_page.vue'

import GroupPage from './components/group/page.vue'
import GroupDiscussionsPanel from './components/group/discussions_panel'

import GroupPollsPanel from './components/group/polls_panel'

import MembersPanel from './components/group/members_panel'
import GroupTagsPanel from './components/group/tags_panel'
import GroupSubgroupsPanel from './components/group/subgroups_panel'
import GroupFilesPanel from './components/group/files_panel'
import MembershipRequestsPanel from './components/group/requests_panel'
import GroupSettingsPanel from './components/group/settings_panel'

import StartGroupPage from './components/start_group/page.vue'
import ContactPage from './components/contact/page.vue'
import EmailSettingsPage from './components/email_settings/page.vue'
import StartDiscussionPage from './components/start_discussion/page.vue'
import UserPage from './components/user/page.vue'
import ThreadsPage from './components/threads/page.vue'

import ThreadNav from './components/thread/nav'

import './config/catch_navigation_duplicated.js'
import Vue from 'vue'
import Router from 'vue-router'

import Session from '@/shared/services/session'

import RescueUnsavedEditsService from '@/shared/services/rescue_unsaved_edits_service'

Vue.use(Router)

groupPageChildren = [
  {path: 'tags/:tag?', component: GroupTagsPanel, meta: {noScroll: true} },
  {path: 'polls', component: GroupPollsPanel, meta: {noScroll: true}}
  {path: 'members', component: MembersPanel, meta: {noScroll: true}}
  {path: 'membership_requests', component: MembershipRequestsPanel, meta: {noScroll: true}}
  {path: 'members/requests', redirect: 'membership_requests', meta: {noScroll: true}}
  {path: 'subgroups', component: GroupSubgroupsPanel, meta: {noScroll: true}}
  {path: 'files', component: GroupFilesPanel, meta: {noScroll: true}}
  {path: 'settings', component: GroupSettingsPanel, meta: {noScroll: true}}
  {path: ':stub?', component: GroupDiscussionsPanel, meta: {noScroll: true}}
]

threadPageChildren = [
  {path: 'comment/:comment_id', components: {nav: ThreadNav}}
  {path: ':stub?/:sequence_id?', components: {nav: ThreadNav}}
  {path: '', components: {nav: ThreadNav}}
]

strandPageChildren = [
  {path: 'comment/:comment_id'}
  {path: ':stub?/:sequence_id?'}
  {path: ''}
]

router = new Router
  mode: 'history'

  scrollBehavior: (to, from, savedPosition) ->
    if savedPosition
      savedPosition
    else if (to.meta.noScroll and from.meta.noScroll)
      window.scrollHeight
    else
      { x: 0, y: 0 }

  routes: [
    {path: '/dashboard', component: DashboardPage},
    {path: '/dashboard/:filter', component: DashboardPage},
    {path: '/threads/direct', component: ThreadsPage},
    {path: '/inbox', component: InboxPage },
    {path: '/explore', component: ExplorePage},
    {path: '/profile', component: ProfilePage},
    {path: '/contact', component: ContactPage},
    {path: '/email_preferences', component: EmailSettingsPage },
    {path: '/p/:key/edit', component: PollFormPage },
    {path: '/p/:key/:stub?', component: PollPage},
    {path: '/u/:key/:stub?', component: UserPage },
    {path: '/d/new', component: StartDiscussionPage },
    {path: '/d/:key/edit', component: StartDiscussionPage },
    {
      path: '/d/:key',
      name: 'discussion',
      component: ThreadPage,
      children: threadPageChildren,
      beforeEnter: (to, from, next) ->
        console.log(to)
        if Session.user().experiences['betaFeatures']
          next(name: 'strand', params: to.params)
        else
          next()
    },
    {path: '/s/:key', name: 'strand', component: StrandPage, children: strandPageChildren },
    {path: '/g/new', component: StartGroupPage},
    {path: '/g/:key', component: GroupPage, children: groupPageChildren, name: 'groupKey'},
    {path: '/:key', component: GroupPage, children: groupPageChildren},
    {path: '/', redirect: '/dashboard' }
  ]

router.beforeEach (to, from, next) ->
  if RescueUnsavedEditsService.okToLeave()
    next()
  else
    next(false)

router.afterEach ->
  RescueUnsavedEditsService.clear()

export default router
