class CloudinaryPopulator
  def self.call(uploaded_file)
    return if uploaded_file.blank?
    return uploaded_file unless uploaded_file.is_a?(ActionDispatch::Http::UploadedFile)
    cloudinary_upload = Cloudinary::Uploader.upload(uploaded_file)
    return if cloudinary_upload.blank?
    cloudinary_upload.with_indifferent_access[:public_id]
  end
end
