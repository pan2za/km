package org.jeecg.modules.KM.common.config;


import org.apache.http.HttpHost;
import org.apache.http.auth.AuthScope;
import org.apache.http.auth.UsernamePasswordCredentials;
import org.apache.http.client.CredentialsProvider;
import org.apache.http.impl.client.BasicCredentialsProvider;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.opensearch.client.RestClient;
import org.opensearch.client.RestClientBuilder;
import org.opensearch.client.opensearch.OpenSearchClient;
import org.opensearch.client.transport.rest_client.RestClientTransport;
import org.opensearch.client.json.jackson.JacksonJsonpMapper;
import org.apache.http.HttpHost;

@Configuration
@ConfigurationProperties(prefix = "esclient")
@EnableConfigurationProperties(ElasticsearchConfig.class)

public class ElasticsearchConfig {

    private String masterHost;
    private Integer masterPort;

    public boolean isMasterAuth() {
        return masterAuth;
    }

    public void setMasterAuth(boolean masterAuth) {
        this.masterAuth = masterAuth;
    }

    private boolean masterAuth;
    private String masterUserName;
    private String masterUserPwd;

    public String getMasterHost() {
        return masterHost;
    }

    public void setMasterHost(String masterHost) {
        this.masterHost = masterHost;
    }

    public Integer getMasterPort() {
        return masterPort;
    }

    public void setMasterPort(Integer masterPort) {
        this.masterPort = masterPort;
    }


    public String getMasterUserName() {
        return masterUserName;
    }

    public void setMasterUserName(String masterUserName) {
        this.masterUserName = masterUserName;
    }

    public String getMasterUserPwd() {
        return masterUserPwd;
    }

    public void setMasterUserPwd(String masterUserPwd) {
        this.masterUserPwd = masterUserPwd;
    }
    /*
     * 创建一个仅支持HTTP的OpenSearch客户端。
     *
     * @return OpenSearchClient 实例
     */
    @Bean
    public OpenSearchClient openSearchClient() {
        // 设置主机信息
        final String hostname = masterHost;
        final int port = masterPort;
        final String scheme = HttpHost.DEFAULT_SCHEME_NAME; // 使用HTTP协议
    
        // 创建RestClient实例
        RestClientBuilder builder = RestClient.builder(new HttpHost(hostname, port, scheme));
    
        // 创建RestClientTransport实例
        RestClientTransport transport = new RestClientTransport(builder.build(), new JacksonJsonpMapper());
    
        // 创建OpenSearchClient实例
        OpenSearchClient client = new OpenSearchClient(transport);
    
        return client;
    }

}
