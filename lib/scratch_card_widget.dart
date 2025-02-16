part of 'scratch_card.dart';

class ScratchCard extends StatelessWidget {
  final Widget child;
  final Color scratchColor;
  final String? scratchImage;
  final ImageType imageType;
  final double stockSize;
 

  const ScratchCard({
    super.key,
    this.imageType = ImageType.asset,
    this.scratchColor = Colors.grey,
    this.scratchImage,
    required this.child,
    this.stockSize = 20, 
  });

  @override
  Widget build(BuildContext context) {
    return ScratchCardSrc(
  
      imageType: imageType,
      scratchColor: scratchColor,
      scratchImage: scratchImage,
      stockSize: stockSize,
      child: child,
    );
  }
}
