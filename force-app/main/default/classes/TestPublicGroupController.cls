@isTest
private class TestPublicGroupController{

	@testSetup static void setup(){

		Group groupObj = new Group (
			DeveloperName = 'testvalue', 
			Name = 'testvalue'
		);
		insert groupObj;
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
		 User userObj = new User (
			IsActive = TRUE, 
			Username = 'testvalue@test.com', 
			LastName = 'testvalue', 
			Email = 'testEmail@gmail.com', 
			EmailPreferencesAutoBcc = TRUE, 
			EmailPreferencesAutoBccStayInTouch = TRUE, 
			EmailPreferencesStayInTouchReminder = TRUE, 
			Alias = 'test', 
			CommunityNickname = 'testvalue', 
			TimeZoneSidKey ='Pacific/Apia', 
			LocaleSidKey ='af', 
			EmailEncodingKey ='UTF-8', 
			ProfileId = profileId.id, 
			LanguageLocaleKey ='en_US', 
			UserPermissionsMarketingUser = TRUE, 
			UserPermissionsOfflineUser = TRUE, 
			UserPermissionsCallCenterAutoLogin = TRUE, 
			UserPermissionsSFContentUser = TRUE, 
			UserPermissionsKnowledgeUser = TRUE, 
			UserPermissionsInteractionUser = TRUE, 
			UserPermissionsSupportUser = TRUE, 
			UserPermissionsJigsawProspectingUser = TRUE, 
			UserPermissionsSiteforceContributorUser = TRUE, 
			UserPermissionsSiteforcePublisherUser = TRUE, 
			UserPermissionsWorkDotComUserFeature = TRUE, 
			UserPreferencesActivityRemindersPopup = TRUE, 
			UserPreferencesEventRemindersCheckboxDefault = TRUE, 
			UserPreferencesTaskRemindersCheckboxDefault = TRUE, 
			UserPreferencesReminderSoundOff = TRUE, 
			UserPreferencesDisableAllFeedsEmail = TRUE, 
			UserPreferencesContentNoEmail = TRUE, 
			UserPreferencesContentEmailAsAndWhen = TRUE, 
			UserPreferencesApexPagesDeveloperMode = TRUE, 
			UserPreferencesReceiveNoNotificationsAsApprover = TRUE, 
			UserPreferencesReceiveNotificationsAsDelegatedApprover = TRUE, 
			UserPreferencesHideCSNGetChatterMobileTask = TRUE, 
			UserPreferencesHideCSNDesktopTask = TRUE, 
			UserPreferencesHideChatterOnboardingSplash = TRUE, 
			UserPreferencesHideSecondChatterOnboardingSplash = TRUE, 
			UserPreferencesHideLegacyRetirementModal = TRUE, 
			UserPreferencesJigsawListUser = TRUE, 
			UserPreferencesShowTitleToExternalUsers = TRUE, 
			UserPreferencesShowManagerToExternalUsers = TRUE, 
			UserPreferencesShowEmailToExternalUsers = TRUE, 
			UserPreferencesShowWorkPhoneToExternalUsers = TRUE, 
			UserPreferencesShowMobilePhoneToExternalUsers = TRUE, 
			UserPreferencesShowFaxToExternalUsers = TRUE, 
			UserPreferencesShowStreetAddressToExternalUsers = TRUE, 
			UserPreferencesShowCityToExternalUsers = TRUE, 
			UserPreferencesShowStateToExternalUsers = TRUE, 
			UserPreferencesShowPostalCodeToExternalUsers = TRUE, 
			UserPreferencesShowCountryToExternalUsers = TRUE, 
			UserPreferencesShowProfilePicToGuestUsers = TRUE, 
			UserPreferencesShowTitleToGuestUsers = TRUE, 
			UserPreferencesShowCityToGuestUsers = TRUE, 
			UserPreferencesShowStateToGuestUsers = TRUE, 
			UserPreferencesShowPostalCodeToGuestUsers = TRUE, 
			UserPreferencesShowCountryToGuestUsers = TRUE, 
			UserPreferencesShowForecastingChangeSignals = TRUE, 
			UserPreferencesHideS1BrowserUI = TRUE, 
			UserPreferencesPathAssistantCollapsed = TRUE, 
			UserPreferencesCacheDiagnostics = TRUE, 
			UserPreferencesShowEmailToGuestUsers = TRUE, 
			UserPreferencesShowManagerToGuestUsers = TRUE, 
			UserPreferencesShowWorkPhoneToGuestUsers = TRUE, 
			UserPreferencesShowMobilePhoneToGuestUsers = TRUE, 
			UserPreferencesShowFaxToGuestUsers = TRUE, 
			UserPreferencesShowStreetAddressToGuestUsers = TRUE, 
			UserPreferencesLightningExperiencePreferred = TRUE, 
			UserPreferencesPreviewLightning = TRUE, 
			UserPreferencesHideEndUserOnboardingAssistantModal = TRUE, 
			UserPreferencesHideLightningMigrationModal = TRUE, 
			UserPreferencesHideSfxWelcomeMat = TRUE, 
			UserPreferencesHideBiggerPhotoCallout = TRUE, 
			UserPreferencesGlobalNavBarWTShown = TRUE, 
			UserPreferencesGlobalNavGridMenuWTShown = TRUE, 
			UserPreferencesCreateLEXAppsWTShown = TRUE, 
			UserPreferencesFavoritesWTShown = TRUE, 
			UserPreferencesRecordHomeSectionCollapseWTShown = TRUE, 
			UserPreferencesRecordHomeReservedWTShown = TRUE, 
			UserPreferencesFavoritesShowTopFavorites = TRUE, 
			UserPreferencesExcludeMailAppAttachments = TRUE, 
			UserPreferencesSuppressTaskSFXReminders = TRUE, 
			UserPreferencesSuppressEventSFXReminders = TRUE, 
			UserPreferencesPreviewCustomTheme = TRUE, 
			UserPreferencesHasCelebrationBadge = TRUE, 
			UserPreferencesUserDebugModePref = TRUE, 
			UserPreferencesSRHOverrideActivities = TRUE, 
			UserPreferencesNewLightningReportRunPageEnabled = TRUE, 
			UserPreferencesReverseOpenActivitiesView = TRUE, 
			UserPreferencesHasSentWarningEmail = TRUE, 
			UserPreferencesNativeEmailClient = TRUE
		);
		insert userObj;
		 
	}

	@isTest static void testMethod1() {
		// code_block	
	}

	@isTest static void testMethod2() {
		// code_block	
	}
}