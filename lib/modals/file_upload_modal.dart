
import 'package:ecare/widgets/custom_circular_image.dart';

class FileUploadModal<T> {
  T filePath;
  String type;
  int id;
  T thumbnail;
  CustomFileType fileType;
  FileUploadModal(
      {required this.filePath,
      required this.type,
      required this.thumbnail,
      required this.id,
      required this.fileType});
  factory FileUploadModal.fromJson(Map json) {
    return FileUploadModal(
      filePath: json['value'],
      type: json['type'],
      id: json['id'] ?? 0,
      fileType: json['fileTpe'] ?? CustomFileType.file,
      thumbnail: json['video_thumbnail'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['filePath'] = filePath;
    data['type'] = type;
    data['thumbnail'] = thumbnail;
    return data;
  }
}
