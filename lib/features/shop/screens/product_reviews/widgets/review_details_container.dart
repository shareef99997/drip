// import 'package:drip/features/shop/screens/product_reviews/widgets/rating_star.dart';
// import 'package:drip/utils/constants/colors.dart';
// import 'package:drip/utils/helpers/helper_functions.dart';
// import 'package:flutter/material.dart';
// import 'package:readmore/readmore.dart';

// import '../../../../../utils/formatters/formatter.dart';
// import '../../../models/product_review_model.dart';


// class UserReviewCard extends StatelessWidget {
//   const UserReviewCard({Key? key, required this.productReview}) : super(key: key);

//   final ProductReviewModel productReview;

//   @override
//   Widget build(BuildContext context) {
//     final dark = THelperFunctions.isDarkMode(context);
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 CircleAvatar(backgroundImage: AssetImage(productReview.userImageUrl ?? '')),
//                 const SizedBox(width: 10.0),
//                 Text(productReview.userName ?? '', style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400)),
//               ],
//             ),
//             IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
//           ],
//         ),
//         const SizedBox(height: 10.0),

//         /// Review
//         Row(
//           children: [

//             ///Review Stars
//             TRatingBarIndicator(rating: productReview.rating),

//             ///Review Date
//             const SizedBox(width: 10.0),
//             Text(TFormatter.formatDate(productReview.timestamp)),
//           ],
//         ),
//         const SizedBox(height: 10.0),

//         ///Review Text
//         ReadMoreText(
//           productReview.comment ?? '',
//           trimLines: 3,
//           colorClickableText: Colors.blue,
//           trimMode: TrimMode.Line,
//           trimExpandedText: '  show less',
//           moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue[700]),
//           lessStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue[700]),
//         ),
//         const SizedBox(height: 10.0),

//         /// Review Reply
//         Container(
//           color: dark ? TColors.darkerGrey : TColors.grey,
//           child: Padding(
//             padding: const EdgeInsets.all(15.0),
//             child: Column(
//               children: [

//                 /// Company Name
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text("T's Store", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
//                     Text(TFormatter.formatDate(productReview.companyTimestamp)),
//                   ],
//                 ),
//                 const SizedBox(height: 10.0),

//                 /// Company Reply
//                 ReadMoreText(
//                   productReview.companyComment ?? '',
//                   trimLines: 3,
//                   colorClickableText: Colors.blue,
//                   trimMode: TrimMode.Line,
//                   trimExpandedText: '  show less',
//                   moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue[700]),
//                   lessStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue[700]),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }