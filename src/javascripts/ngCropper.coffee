angular.module("ngCropper", []).directive "ngCropper", ->

  'use strict'

  restrict: "EAC"

  scope:
    ngCropper: '='

  link: (scope, element) ->
    $container = $(element).closest('.ngdialog-content')
    $areaSelect = undefined

    $resultImage = undefined

    $cropSandbox = $('<canvas id="crop_canvas"></canvas>')
    $cropSandbox.attr
      width: 200
      height: 200

    $container.append($cropSandbox)

    element.bind "change", (changeEvent) ->

      if changeEvent.target.files[0] != undefined
        return unless fileAllowed(changeEvent.target.files[0].name)

      reader = new FileReader()

      if reader
        reader.onload = (loadEvent) ->
          resultImage = loadEvent.target.result

          scope.$apply ->
            scope.ngCropper.original = resultImage
            return

          if resultImage
            $areaSelect = $('#preview-image').imgAreaSelect
              handles: true
              aspectRatio: '1:1'
              x1: 0
              y1: 0
              x2: 200
              y2: 200
              parent: $('.image-crop-form .preview')
              instance: true
              onInit: (img, selection) ->
                drawImage($('#preview-image'), selection.x1, selection.y1, selection.width - 1, selection.height - 1)
              onSelectEnd: (img, selection) ->
                drawImage($('#preview-image'), selection.x1, selection.y1, selection.width - 1, selection.height - 1)

            if $areaSelect
              $selection = $areaSelect.getSelection
              if $selection
                drawImage($('#preview-image'), $selection().x1, $selection().y1, $selection().width - 1, $selection().height - 1)

          return

        reader.readAsDataURL changeEvent.target.files[0]
        return

    drawImage = (img, x, y, width, height) ->

      imgDimension =
        width: $('.imgDimensions').width()
        height: $('.imgDimensions').height()

      oWidth = imgDimension.width
      oHeight = imgDimension.height

      if oWidth > oHeight
        r = oHeight / img.height()
      else
        r = oWidth / img.width()

      sourceX = Math.round(x * r)
      sourceY = Math.round(y * r)
      sourceWidth = Math.round(width  * r)
      sourceHeight = Math.round(height * r)
      destX = 0
      destY = 0
      destWidth = 200
      destHeight = 200

      context = $cropSandbox.get(0).getContext('2d')
      context.drawImage(img.get(0), sourceX, sourceY, sourceWidth, sourceHeight, destX, destY, destWidth, destHeight)

      $resultImage = $cropSandbox.get(0).toDataURL()
      if $resultImage
        scope.$apply ->
          scope.ngCropper.result = $resultImage

    fileAllowed = (name) ->
      res = name.match /\.(jpg|png|gif|jpeg)$/mi
      if !res
        scope.$apply ->
          scope.ngCropper.error = 'Only *.jpeg, *.jpg, *.png, *.gif files allowed'
        false
      else
        scope.$apply ->
          scope.ngCropper.error = ''
        true

    return
