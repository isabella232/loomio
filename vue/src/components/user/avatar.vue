<script lang="coffee">
import { is2x } from '@/shared/helpers/window'
import Gravatar from 'vue-gravatar';
import Records from '@/shared/services/records'

export default
  components:
    'v-gravatar': Gravatar
  props:
    user:
      type: Object
      default: -> Records.users.build()

    coordinator: Boolean
    size:
      type: [String, Number]
      default: 36
    noLink: Boolean
    colors: Object

  computed:
    width: ->
      if parseInt(@size)
        parseInt(@size)
      else
        switch @size
          when 'tiny'      then 20
          when 'small'     then 24
          when 'thirtysix' then 36
          when 'forty'     then 40
          when 'medium'    then 48
          when 'large'     then 64
          when 'featured'  then 200

    gravatarSize: ->
      if is2x() then 2*@width else @width

    uploadedAvatarUrl: ->
      return unless @user.avatarKind == 'uploaded'
      return @user.avatarUrl if typeof @user.avatarUrl is 'string'
      @user.avatarUrl['large']

    componentType:  ->
      if @noLink or !@user.id
        'div'
      else
        'router-link'

</script>

<template lang="pug">
component.user-avatar(aria-hidden="true" :is="componentType" :to="!noLink && urlFor(user)" :style="{ 'width': width + 'px', margin: '0' }")
  v-avatar.user-avatar--outline(:title='user.name' :size='width')
    v-gravatar(v-if="user.avatarKind === 'gravatar'" :hash='user.emailHash' :gravatar-size='gravatarSize' :alt='user.avatarInitials')
    img(v-else-if="user.avatarKind === 'uploaded'" :alt='user.avatarInitials' :src='uploadedAvatarUrl')
    span.user-avatar--initials(v-else-if="user.avatarKind === 'initials'" :style="{width: width+'px', height: width+'px'}") {{user.avatarInitials}}
    v-icon(v-else) mdi-account
</template>

<style lang="sass">
.user-avatar--initials
  font-size: 15px
  display: flex
  align-items: center
  justify-content: center
.user-avatar--outline
  border: 1px solid #ddd
  border-radius: 100%
</style>
