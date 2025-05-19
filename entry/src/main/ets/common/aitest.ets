import http from '@ohos.net.http';
import util from '@ohos.util';

interface BaiduAuthResponse {
  access_token: string;
  expires_in: number;
}

interface SummaryRequest {
  title: string;
  content: string;
  max_summary_len?: number;
}

interface SummaryResponse {

  summary: string;
  error_code?: number;
  error_msg?: string;
}

export class BaiduNLPService {
  private static readonly API_KEY: string = 'KZFbchoOD3vouSDatNYhOF2Z';
  private static readonly SECRET_KEY: string = 'bhVf2CvyBnDwPGJVofK5ERAelLjqjPLB';
  private static readonly AUTH_URL: string = 'https://aip.baidubce.com/oauth/2.0/token';
  private static readonly SUMMARY_URL: string = 'https://aip.baidubce.com/rpc/2.0/nlp/v1/news_summary';
  private static readonly TIMEOUT: number = 10000; // 10 seconds timeout

  /**
   * 处理文本编码
   * @param text 输入文本
   * @returns 处理后的文本
   */
  private static processText(text: string): string {
    // 移除特殊字符和表情符号
    return text.replace(/[\uD800-\uDBFF][\uDC00-\uDFFF]|[^\x00-\x7F]/g, '')
      .replace(/[^\u4e00-\u9fa5a-zA-Z0-9，。！？、：；""''（）【】《》]/g, '')
      .trim();
  }

  /**
   * 获取百度AI的access_token
   * @returns access_token字符串
   */
  private static async getAccessToken(): Promise<string> {
    const url: string = `${BaiduNLPService.AUTH_URL}?grant_type=client_credentials&client_id=${BaiduNLPService.API_KEY}&client_secret=${BaiduNLPService.SECRET_KEY}`;

    return new Promise<string>((resolve: (value: string) => void, reject: (reason?: string) => void) => {
      const httpRequest = http.createHttp();
      httpRequest.request(
        url,
        {
          method: http.RequestMethod.POST,
          expectDataType: http.HttpDataType.STRING,
          connectTimeout: BaiduNLPService.TIMEOUT,
          readTimeout: BaiduNLPService.TIMEOUT,
          header: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          }
        },
        (err: Error | undefined, data: http.HttpResponse) => {
          if (err) {
            console.error('获取access_token失败:', err.message);
            reject('网络请求失败: ' + err.message);
            return;
          }
          
          if (!data || data.responseCode !== 200) {
            console.error('获取access_token失败:', data?.responseCode);
            reject('服务器响应错误: ' + data?.responseCode);
            return;
          }

          if (typeof data.result !== 'string') {
            console.error('获取access_token失败: 响应格式错误');
            reject('响应格式错误');
            return;
          }

          try {
            const result: BaiduAuthResponse = JSON.parse(data.result);
            if (!result.access_token) {
              reject('获取access_token失败: 响应中没有token');
              return;
            }
            resolve(result.access_token);
          } catch (e) {
            console.error('解析响应失败:', e);
            reject('解析响应失败');
          } finally {
            httpRequest.destroy();
          }
        }
      );
    });
  }

  /**
   * 调用百度AI新闻摘要API
   * @param title 新闻标题
   * @param content 新闻内容
   * @param maxLength 最大摘要长度，默认200字
   * @returns 新闻摘要
   */
  static async generateSummary(title: string, content: string, maxLength: number = 200): Promise<string> {
    try {
      // 处理输入文本
      const processedTitle = BaiduNLPService.processText(title);
      const processedContent = BaiduNLPService.processText(content);

      if (!processedTitle || !processedContent) {
        throw new Error('标题或内容不能为空');
      }

      const accessToken = await BaiduNLPService.getAccessToken();
      const url: string = `${BaiduNLPService.SUMMARY_URL}?access_token=${accessToken}`;
      
      const headers: Record<string, string> = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json'
      };

      const body: SummaryRequest = {
        title: processedTitle,
        content: processedContent,
        max_summary_len: maxLength
      };

      return new Promise<string>((resolve: (value: string) => void, reject: (reason?: string) => void) => {
        const httpRequest = http.createHttp();
        httpRequest.request(
          url,
          {
            method: http.RequestMethod.POST,
            header: headers,
            extraData: JSON.stringify(body),
            expectDataType: http.HttpDataType.STRING,
            connectTimeout: BaiduNLPService.TIMEOUT,
            readTimeout: BaiduNLPService.TIMEOUT
          },
          (err: Error | undefined, data: http.HttpResponse) => {
            if (err) {
              console.error('生成摘要失败:', err.message);
              reject('网络请求失败: ' + err.message);
              return;
            }

            if (!data || data.responseCode !== 200) {
              console.error('生成摘要失败:', data?.responseCode);
              reject('服务器响应错误: ' + data?.responseCode);
              return;
            }

            if (typeof data.result !== 'string') {
              console.error('生成摘要失败: 响应格式错误');
              reject('响应格式错误');
              return;
            }

            try {
              const result: SummaryResponse = JSON.parse(data.result);
              if (result.error_code) {
                console.error('API错误:', result.error_msg);
                reject(`API错误: ${result.error_msg}`);
                return;
              }
              if (!result.summary) {
                reject('生成摘要失败: 响应中没有摘要内容');
                return;
              }
              resolve(result.summary);
            } catch (e) {
              console.error('解析响应失败:', e);
              reject('解析响应失败');
            } finally {
              httpRequest.destroy();
            }
          }
        );
      });
    } catch (error) {
      console.error('生成摘要过程出错:', error);
      return Promise.reject(error);
    }
  }
}
