package com.ruoyi.common.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 * 阿里云OSS配置类
 * 
 * @author ruoyi
 */
@Component
@ConfigurationProperties(prefix = "aliyun.oss")
public class OssConfig
{
    /** OSS endpoint */
    private String endpoint;

    /** AccessKey ID */
    private String accessKeyId;

    /** AccessKey Secret */
    private String accessKeySecret;

    /** Bucket名称 */
    private String bucketName;

    /** OSS访问URL前缀 */
    private String urlPrefix;

    public String getEndpoint()
    {
        return endpoint;
    }

    public void setEndpoint(String endpoint)
    {
        this.endpoint = endpoint;
    }

    public String getAccessKeyId()
    {
        return accessKeyId;
    }

    public void setAccessKeyId(String accessKeyId)
    {
        this.accessKeyId = accessKeyId;
    }

    public String getAccessKeySecret()
    {
        return accessKeySecret;
    }

    public void setAccessKeySecret(String accessKeySecret)
    {
        this.accessKeySecret = accessKeySecret;
    }

    public String getBucketName()
    {
        return bucketName;
    }

    public void setBucketName(String bucketName)
    {
        this.bucketName = bucketName;
    }

    public String getUrlPrefix()
    {
        return urlPrefix;
    }

    public void setUrlPrefix(String urlPrefix)
    {
        this.urlPrefix = urlPrefix;
    }
}
