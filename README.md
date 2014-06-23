ngCropper
=========

ngCropper is Angular directive for upload images with cropping tool.

Dependencies:

	ngDialog
	imgAreaSelect

Example:

In this example i used Twitter Bootstrap.
Templates - haml.
Scripts - CoffeeScript.

	View(haml): 

		.ico.ico-crop
			%div{'ng-if' => '!user.logo'}
			  = image_tag 'ico/ico_user_default.png', alt: '', height: '80', width: '80'
			%div{'ng-if' => 'user.logo'}
			  %img{'ng-src' => '{{user.logo}}', alt: '', height: '80', width: '80'}

			.btn.btn-default.btn-crop{'ng-click' => 'openCropperForm()'}
			  .inner
			    %span.caption Change logo


	Template:

		%script#image-crop-form{type: 'text/ng-template'}

		    .alert.alert-danger{'ng-if' => 'cropImage.error'}
		      %i.icon-ban-circle.icon-large
		        {{cropImage.error}}

		    .btn.btn-primary.btn-file-select
		      Select file
		      %input.inner-file-input{type: 'file', 'ng-cropper' => 'cropImage'}
		    .preview{'ng-if' => 'cropImage.original'}
		      %img#preview-image{'ng-src' => '{{cropImage.original}}'}
		      %img.imgDimensions{'ng-src' => '{{cropImage.original}}'}
		      .actions
		        .btn-group
		          .btn.btn-primary{'ng-click' => 'applySelection()'} Save
		          .btn.btn-danger{'ng-click' => 'cancelSelection()'} Cancel

	Controller:

		$scope.openCropperForm = () ->
		      ngDialog.open
		        template: 'image-crop-form'
		        className: 'ngdialog-theme-default image-crop-form'
		        controller: 'UserCtrl'
		        scope: $scope

		    $scope.applySelection = ->
		      console.log($scope.cropImage)
		      $scope.$parent.user.logo = $scope.cropImage.result unless $scope.cropImage.result == ''
		      ngDialog.close()

		    $scope.cancelSelection = ->
		      ngDialog.close()