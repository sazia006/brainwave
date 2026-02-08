import 'package:cloudinary_public/cloudinary_public.dart';

class CloudinaryService {
  final cloudinary = CloudinaryPublic(
    'dml42cnl6', // <-- your cloud name
    'brainwave_upload', // <-- preset name you just created
    cache: false,
  );

  Future<String> uploadImage(String path) async {
    final response = await cloudinary.uploadFile(
      CloudinaryFile.fromFile(path, resourceType: CloudinaryResourceType.Image),
    );

    return response.secureUrl;
  }
}
