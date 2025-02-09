library widgets;

import 'package:badges/badges.dart';
import 'package:flutter/material.dart' hide Durations, Badge;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svg_provider;
import 'package:healsense/application/providers/create_medicine_provider/provider/create_medicine_provider.dart';
import 'package:healsense/application/providers/delete_medicine_provider/provider/delete_medicine_provider.dart';
import 'package:healsense/application/providers/is_today_reminder_exist_provider/is_today_reminder_exist_provider.dart';
import 'package:healsense/application/providers/latest_medicine_provider/provider/latest_medicine_provider.dart';
import 'package:healsense/application/providers/today_active_medicines_provider/provider/today_active_medicines_provider.dart';
import 'package:healsense/application/providers/today_reminders_count_provider/provider/today_reminders_count_provider.dart';
import 'package:healsense/infastructure/core/constants/typedefs.dart';
import 'package:healsense/infastructure/core/extensions/first_character_capitalize_extension.dart';
import 'package:healsense/infastructure/core/extensions/localization_extension.dart';
import 'package:healsense/infastructure/core/extensions/location_url_extension.dart';
import 'package:healsense/infastructure/core/extensions/uri_parse_extension.dart';
import 'package:healsense/infastructure/core/helpers/cupertino_picker_helper.dart';
import 'package:healsense/infastructure/core/helpers/snackbar_helper.dart';
import 'package:healsense/infastructure/core/utils/date_format_util.dart';
import 'package:go_router/go_router.dart';
import 'package:healsense/infastructure/core/constants/assets.dart';
import 'package:healsense/infastructure/core/constants/durations.dart';
import 'package:healsense/infastructure/core/constants/paddings.dart';
import 'package:healsense/infastructure/core/constants/text_styles.dart';
import 'package:healsense/infastructure/core/extensions/responsive_size_extension.dart';
import 'package:healsense/presentation/widgets/common/bottom_navigation_bar/fancy_bottom_navigation_bar.dart';
import 'package:healsense/presentation/widgets/common/bottom_navigation_bar/fancy_button.dart';
import 'package:healsense/presentation/widgets/common/snackbars/simple_snackbar_icon.dart';
import 'package:nil/nil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../application/providers/create_medicine_provider/state/create_medicine_form_state.dart';
import '../../application/providers/date_picker_timeline_provider/provider/date_picker_timeline_provider.dart';
import '../../application/providers/create_medicine_notification_provider/provider/create_medicine_notification_provider.dart';
import '../../application/providers/intro_page_slider_provider/state/intro_page_state.dart';
import '../../application/providers/medicines_by_date_provider/provider/medicines_by_date_provider.dart';
import '../../application/providers/navigation_tab_provider/provider/navigation_tab_provider.dart';
import '../../application/providers/nearby_pharmacies_provider/provider/nearby_pharmacies_provider.dart';
import '../../infastructure/core/constants/palette.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../infastructure/core/helpers/shimmer_helper.dart';
import '../../infastructure/core/utils/medicine_type_selection_util.dart';
import '../../domain/core/error/exceptions.dart';
import '../../application/providers/go_router_provider/routes/routes.dart';
import '../../infastructure/core/utils/pharmacy_thumbnails_util.dart';
import '../../infastructure/core/utils/time_later/time_later_util.dart';
import '../../domain/entities/intro_page_slider.dart';
import '../../infastructure/models/nearby_pharmacies.dart';
import '../../application/providers/intro_page_slider_provider/notifier/intro_page_state_notifier.dart';
import '../../infastructure/services/drift_service/drift_service.dart';
import 'common/clippers/oval_bottom_border_clipper.dart';
import 'common/date_picker_timeline/date_picker_timeline.dart';
import 'common/loading/jumping_dots/index.dart';
import 'common/snackbars/simple_snackbar_content_type.dart';

part 'intro/intro_page_slider_item.dart';
part 'intro/intro_page_slider_thumbnail.dart';
part 'intro/intro_page_slider_skip_button.dart';
part 'intro/intro_page_slider_title.dart';
part 'intro/intro_page_slider_desc.dart';
part 'intro/dots/intro_page_slider_dots.dart';
part 'intro/dots/intro_page_slider_dot_item.dart';
part 'intro/intro_page_slider_button.dart';
part 'intro/intro_page_slider_oval_clip.dart';
part 'common/spacers/horizontal_spacer.dart';
part 'common/spacers/vertical_spacer.dart';
part 'common/dividers/horizontal_divider.dart';
part 'splash/splash_thumbnail.dart';
part 'calendar/calendar_timeline/calendar_date_picker_timeline.dart';
part 'feed/feed_top_reminder_item/feed_top_reminder_item.dart';
part 'feed/feed_notification_overview/feed_notification_view/feed_notification_view_box.dart';
part 'feed/feed_notification_overview/feed_notification_details_box/feed_notification_details_box.dart';
part 'common/bottom_navigation_bar/custom_bottom_navigation_bar.dart';
part 'feed/feed_health_condition_statement/feed_health_condition_statement.dart';
part 'feed/feed_notification_overview/feed_notification_overview.dart';
part 'feed/feed_pharmacies_nearby/feed_pharmacies_nearby_title.dart';
part 'feed/feed_pharmacies_nearby/feed_pharmacies_nearby_places.dart';
part 'feed/feed_pharmacies_nearby/feed_pharmacies_nearby_place_overview.dart';
part 'feed/feed_pharmacies_nearby/feed_pharmacies_nearby_place_thumbnail.dart';
part 'feed/feed_pharmacies_nearby/loading/feed_find_pharmacies_nearby_loading.dart';
part 'feed/feed_pharmacies_nearby/loading/feed_find_pharmacies_nearby_icon.dart';
part 'common/error_or_empty/error_or_empty.dart';
part 'feed/feed_pharmacies_nearby/feed_pharmacies_nearby_place_item.dart';
part 'calendar/calendar_thumbnail.dart';
part 'calendar/calendar_timeline/calendar_date_and_month.dart';
part 'calendar/calendar_timeline/calendar_year.dart';
part 'calendar/calendar_timeline/calendar_month.dart';
part 'calendar/calendar_timeline/calendar_date.dart';
part 'calendar/calendar_activities/calendar_activities.dart';
part 'calendar/calendar_activities/calendar_activity.dart';
part 'create_medicine/create_medicine_thumbnail.dart';
part 'create_medicine/form/create_medicine_form_notification_field.dart';
part 'create_medicine/form/create_medicine_form.dart';
part 'common/date_picker/cupertino_date_picker.dart';
part 'create_medicine/form/create_medicine_form_field_title.dart';
part 'create_medicine/form/create_medicine_form_text_field.dart';
part 'create_medicine/form/create_medicine_form_submit_button.dart';
part 'common/time_picker/cupertino_time_picker.dart';
part 'common/medicine_type_picker/medicine_type_picker.dart';
part 'common/loading/jumping_dots/jumping_dots_indicator.dart';
part 'common/reminder_activity/reminder_activity_amount_box.dart';
part 'common/reminder_activity/reminder_activity_medicine_icon.dart';
part 'common/reminder_activity/reminder_activity_medicine_name_and_type.dart';
part 'common/reminder_activity/reminder_activity_timeline.dart';
part 'common/loading/shimmer/shimmer_loading_indicator.dart';
part 'common/mediaquery_remove_padding.dart';
part 'common/snackbars/simple_snackbar_content.dart';
part 'calendar/calendar_activities/activity_dismissible/calendar_activity_dismissible.dart';
part 'calendar/calendar_activities/activity_dismissible/calendar_activity_dismissible_left_transition.dart';
part 'feed/feed_notification_overview/feed_notification_details_box/feed_reminder_details_box_date.dart';
part 'feed/feed_notification_overview/feed_notification_details_box/feed_reminder_details_box_title_desc.dart';
part 'feed/feed_notification_overview/feed_notification_details_box/feed_reminder_details_box_icon.dart';
part 'reminders/reminders_back_button.dart';
part 'reminders/reminders.dart';
part 'reminders/reminders_activity.dart';
