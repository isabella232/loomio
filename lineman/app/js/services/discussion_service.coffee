angular.module('loomioApp').service 'DiscussionService',
  class DiscussionService
    constructor: (@$http, @RecordStoreService) ->

    fetchByKey: (key, success, failure) ->
      @$http.get("/api/v1/discussions/#{key}").then (response) =>
        console.log response
        @RecordStoreService.importRecords(response.data)
        @RecordStoreService.getByKey('discussions', key)
      , (response) ->
        failure(response.data.error)
