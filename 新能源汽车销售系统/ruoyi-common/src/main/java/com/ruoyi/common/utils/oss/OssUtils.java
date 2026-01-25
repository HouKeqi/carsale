package com.ruoyi.common.utils.oss;

import java.io.InputStream;
import org.apache.commons.io.FilenameUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;
import com.aliyun.oss.OSS;
import com.aliyun.oss.OSSClientBuilder;
import com.aliyun.oss.model.PutObjectRequest;
import com.ruoyi.common.config.OssConfig;
import com.ruoyi.common.exception.file.FileNameLengthLimitExceededException;
import com.ruoyi.common.exception.file.FileSizeLimitExceededException;
import com.ruoyi.common.exception.file.InvalidExtensionException;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.file.FileUploadUtils;
import com.ruoyi.common.utils.file.MimeTypeUtils;
import com.ruoyi.common.utils.uuid.Seq;

/**
 * 阿里云OSS工具类
 * 
 * @author ruoyi
 */
@Component
public class OssUtils
{
    private static final Logger log = LoggerFactory.getLogger(OssUtils.class);

    @Autowired
    private OssConfig ossConfig;

    /**
     * 默认大小 50M
     */
    public static final long DEFAULT_MAX_SIZE = 50 * 1024 * 1024L;

    /**
     * 默认的文件名最大长度 100
     */
    public static final int DEFAULT_FILE_NAME_LENGTH = 100;

    /**
     * 上传文件到OSS
     * 
     * @param file 上传的文件
     * @return 文件访问URL
     * @throws Exception
     */
    public String uploadFile(MultipartFile file) throws Exception
    {
        // 验证文件
        validateFile(file);

        // 生成文件名
        String fileName = generateFileName(file);

        // OSS对象键（文件路径）
        String objectKey = "vehicle/" + fileName;

        // 创建OSS客户端
        OSS ossClient = new OSSClientBuilder().build(
                ossConfig.getEndpoint(),
                ossConfig.getAccessKeyId(),
                ossConfig.getAccessKeySecret());

        try
        {
            // 上传文件
            InputStream inputStream = file.getInputStream();
            PutObjectRequest putObjectRequest = new PutObjectRequest(
                    ossConfig.getBucketName(),
                    objectKey,
                    inputStream);
            ossClient.putObject(putObjectRequest);

            // 构建文件访问URL
            String fileUrl = ossConfig.getUrlPrefix() + "/" + objectKey;
            log.info("文件上传成功: {}", fileUrl);
            return fileUrl;
        }
        catch (Exception e)
        {
            log.error("OSS文件上传失败", e);
            throw new Exception("文件上传失败: " + e.getMessage());
        }
        finally
        {
            // 关闭OSS客户端
            if (ossClient != null)
            {
                ossClient.shutdown();
            }
        }
    }

    /**
     * 验证文件
     * 
     * @param file 上传的文件
     * @throws FileSizeLimitExceededException
     * @throws InvalidExtensionException
     * @throws FileNameLengthLimitExceededException
     */
    private void validateFile(MultipartFile file)
            throws FileSizeLimitExceededException, InvalidExtensionException, FileNameLengthLimitExceededException
    {
        // 文件大小校验
        long size = file.getSize();
        if (size > DEFAULT_MAX_SIZE)
        {
            throw new FileSizeLimitExceededException(DEFAULT_MAX_SIZE / 1024 / 1024);
        }

        // 文件名长度校验
        int fileNamelength = file.getOriginalFilename().length();
        if (fileNamelength > DEFAULT_FILE_NAME_LENGTH)
        {
            throw new FileNameLengthLimitExceededException(DEFAULT_FILE_NAME_LENGTH);
        }

        // 文件扩展名校验
        String extension = FileUploadUtils.getExtension(file);
        if (!FileUploadUtils.isAllowedExtension(extension, MimeTypeUtils.DEFAULT_ALLOWED_EXTENSION))
        {
            throw new InvalidExtensionException(MimeTypeUtils.DEFAULT_ALLOWED_EXTENSION, extension,
                    file.getOriginalFilename());
        }
    }

    /**
     * 生成文件名
     * 格式: yyyy/MM/dd/原文件名_序列号.扩展名
     * 
     * @param file 上传的文件
     * @return 文件名
     */
    private String generateFileName(MultipartFile file)
    {
        String extension = FileUploadUtils.getExtension(file);
        String baseName = FilenameUtils.getBaseName(file.getOriginalFilename());
        String datePath = DateUtils.datePath();
        String seqId = Seq.getId(Seq.uploadSeqType);
        return StringUtils.format("{}/{}_{}.{}", datePath, baseName, seqId, extension);
    }
}
