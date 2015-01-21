//
//  UserClauseViewController.m
//  UThing
//
//  Created by Apple on 14/11/19.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "UserClauseViewController.h"

@interface UserClauseViewController ()

@end

@implementation UserClauseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"隐私条款";
    

    UIScrollView *clauseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-30)];
    clauseScrollView.backgroundColor = [UIColor whiteColor];
    
    NSString *info = @"一、特别提示\r欢迎您来到游心网/游心旅行，Uthing.cn的所有权与运作权归属宁波游心信息科技发展有限公司（以下简称游心）。请您仔细阅读以下条款，如果您对本协议的任何条款表示异议，您可以选择不进入游心网。游心网提供的服务将完全按照其发布的使用协议、服务条款和操作规则严格执行。为获得游心服务，服务使用人（以下称“用户”）应当同意本协议的全部条款并按照页面上的提示完成全部的注册程序。当您注册成功，无论是进入游心网，还是在游心旅行上发布任何内容（即“内容”），均意味着您完全接受本协议项下的全部条款。\r会员同意遵守《中华人民共和国保密法》、《计算机信息系统国际联网保密管理规定》、《中华人民共和国计算机信息系统安全保护条例》、《计算机信息网络国际联网安全保护管理办法》、《中华人民共和国计算机信息网络国际联网管理暂行规定》及其实施办法等相关法律法规的任何及所有的规定，并对会员以任何方式使用服务的任何行为及其结果承担全部责任。在任何情况下，如果本网站合理地认为会员的任何行为，包括但不限于会员的任何言论和其他行为违反或可能违反上述法律和法规的任何规定，本网站可在任何时候不经任何事先通知终止向会员提供服务。\r本网站可能不时的修改本协议的有关条款，一旦条款内容发生变动，本网站将会在相关的页面提示修改内容。在更改此使用服务协议时，本网站将说明更改内容的执行日期，变更理由等。且应同现行的使用服务协议一起，在更改内容发生效力前7日内及发生效力前日向会员公告。会员需仔细阅读使用服务协议更改内容，会员由于不知变更内容所带来的伤害，本网站一概不予负责。如果不同意本网站对服务条款所做的修改，用户有权停止使用网络服务。如果用户继续使用网络服务，则视为用户接受服务条款的变动。\r\r二、服务内容\r2.1 本服务的具体内容由游心根据实际情况提供，游心对其所提供之服务有最终解释权，同时保留随时变更、中断或终止部分或全部服务的权利。游心网不承担因业务调整给用户造成的损失。除非本协议另有其它明示规定，增加或强化目前本服务的任何新功能，包括所推出的新产品，均受到本协议之规范。用户了解并同意，本服务仅依其当前所呈现的状况提供，对于任何用户通讯或个人化设定之时效、删除、传递错误、未予储存或其它任何问题，游心均不承担任何责任。\r2.2 游心在Uthing.cn上向其用户提供包括在线酒店及旅游项目预订在内的相关网络服务。与相关网络服务有关的设备（如个人电脑、手机、及其他与接入互联网或移动网有关的装置）及所需的费用（如为接入互联网而支付的电话费及上网费、为使用移动网而支付的手机费）均由会员自行负担。\r\r三、会员帐号及密码\r您注册会员成功后，将得到一个帐号和密码。您应妥善保管该帐号及密码，并对以该帐号进行的所有活动及事件负法律责任。因黑客行为或会员保管疏忽致使帐号、密码被他人非法使用的，游心不承担任何责任。如您发现任何非法使用会员帐号或安全漏洞的情况，请立即与游心联系。\r\r四、用户规则\r3.1 用户须对在游心网的注册信息的真实性、合法性、有效性承担全部责任，用户不得冒充他人；不得利用他人的名义发布任何信息；不得恶意使用注册帐户导致其他用户误认；否则游心有权立即停止提供服务，收回其帐号并由用户独自承担由此而产生的一切法律责任。\r3.2 用户承诺不得以任何方式利用游心网直接或间接从事违反中国法律、以及社会公德的行为，游心网有权对违反上述承诺的内容予以删除。\r3.3 用户不得利用游心网服务制作、上载、复制、发布、传播或者转载如下内容：\r1)	反对宪法所确定的基本原则的；\r2)	危害国家安全，泄露国家秘密，颠覆国家政权，破坏国家统一的；\r3)	损害国家荣誉和利益的；\r4)	煽动民族仇恨、民族歧视，破坏民族团结的；\r5)	破坏国家宗教政策，宣扬邪教和封建迷信的；\r6)	散布谣言，扰乱社会秩序，破坏社会稳定的；\r7)	散布淫秽、色情、赌博、暴力、凶杀、恐怖或者教唆犯罪的；\r8)	侮辱或者诽谤他人，侵害他人合法权益的；\r9)	含有法律、行政法规禁止的其他内容的信息。\r3.4 游心有权对用户使用面包旅行的情况进行审查和监督，如用户在使用游心网时违反任何上述规定，游心或其授权的人有权要求用户改正或直接采取一切必要的措施（包括但不限于更改或删除用户张贴的内容、暂停或终止用户使用游心网的权利）以减轻用户不当行为造成的影响；\r3.5用户不得利用游心服务系统进行任何其他不利于游心网站的行为。\r\r五、隐私权条款\r5.1 保护用户隐私是游心网的一项基本政策，游心保证不对外公开或向第三方提供用户注册资料及用户在使用本服务时存储在游心网的非公开内容，但下列情况除外：\r1)	事先获得用户的明确授权；\r2)	根据有关的法律法规要求；\r3)	按照相关政府主管部门的要求；\r4)	为维护社会公众的利益；\r5)	维护游心的合法权益；\r6)	服务器等设备故障导致的情况。\r5.2 用户自愿注册个人信息，用户在注册时提供的所有信息，都是基于自愿，用户有权在任何时候拒绝提供这些信息。注册个人信息的用户同意游心网对这些信息进行善意利用。游心网使用目前业界高可靠性的服务器软件，支持安全加密协议。我们会运用这套软件并采用多种方法在最大程度上来确保用户提供的信息不被非法访问。用户明确同意其使用游心网网络服务所存在的风险将完全由其自己承担。\r5.3在不透露单个用户隐私资料的前提下，游心网有权对整个用户数据库进行分析并对用户数据库进行商业上的利用。\r\r六、知识产权\r6.1 游心在网络服务中提供的任何文本、图片、图形、音频和视频资料均受版权、商标权以及其他相关法律法规的保护。未经游心事先同意，任何人不能擅自复制、传播这些内容，或用于其他任何商业目的，所有这些资料或资料的任何部分仅可作为个人或非商业用途而保存在某台计算机内。\r6.2 本网站用户在攻略及论坛频道上传的资料内容（包括但不限于图片、视频、Flash、点评等），应保证为原创或已得到充分授权，并具有准确性、真实性、正当性、合法性，且不含任何侵犯第三人权益的内容，因抄袭、转载、侵权等行为所产生的纠纷由用户自行解决，本网站不承担任何法律责任。\r6.3 如有著作权人发现会员在游心发表的内容侵犯其著作权，并依《互联网著作权行政保护办法》、《信息网络传播保护条例》的规定向游心发出书面通知并提供相关内容的著作权权属证明的，游心有权在不事先通知会员的情况下自行移除相关内容，并依法保留相关数据。\r6.4“游心网”、游心及“uthing.cn”组合为宁波游心信息科技发展有限公司注册商标，任何人不得擅自使用，否则，将依法追究法律责任。\r\r七、免责声明\r7.1 游心对任何因会员不正当或非法使用服务、在网上进行交易、或会员传送信息变动而产生的直接、间接、偶然、特殊及后续的损害不承担责任。\r7.2 游心对任何他人的威胁性的、诽谤性的、淫秽的、令人反感的或非法的内容或行为或对他人权利的侵犯（包括知识产权）不承担责任；并对任何第三方通过服务发送或在服务中包含的任何内容不承担责任。\r7.3 会员明确同意其使用游心服务所存在的风险以及使用游心网络服务产生的一切后果由其自己承担。会员自行上传或通过网络收集的资源，游心仅提供一个展示、交流的平台，不对其内容的准确性、真实性、正当性、合法性负责，也不承担任何法律责任。\r7.4 对于因不可抗力或游心不能控制的原因造成的网络服务中断或其它缺陷，游心不承担任何责任，但将尽力减少因此而给用户造成的损失和影响。\r7.5 游心网不担保网络服务一定能满足用户的要求，也不担保网络服务不会中断，对网络服务的及时性、安全性、准确性也都不做担保。\r7.6游心网不保证为向用户提供便利而设置的外部链接的准确性和完整性，同时，对于该等外部链接指向的任何网页上的内容，游心不承担任何责任。\r\r八、服务变更、中断或终止\r如因系统维护或升级的需要而需暂停服务，本网站将尽可能事先进行通告。\r如发生下列任何一种情形，本网站有权随时中断或终止向用户提供本协议项下的服务而无需通知用户：\r•	用户提供的个人资料不真实；\r•	用户违反本协议中规定的使用规则。\r除前款所述情形外，本网站同时保留在不事先通知用户的情况下随时中断或终止部分或全部服务的权利，对于所有服务的中断或终止而造成的任何损失，本网站无需对用户或任何第三方承担任何责任。\r\r九、违约赔偿\r用户同意保障和维护本网站及其他用户的利益，如因用户违反有关法律、法规或本协议项下的任何条款而给本网站或任何其他第三者造成损失，用户同意承担由此造成的损害赔偿责任。\r\r十、修改协议\r本网站将可能不时的修改本协议的有关条款，一旦条款内容发生变动，本网站将会在相关的页面提示修改内容。\r如果不同意本网站对服务条款所做的修改，用户有权停止使用服务。如果用户继续使用服务，则视为用户接受服务条款的变动。\r\r十一、法律管辖\r本协议的订立、执行和解释及争议的解决均应适用中国法律。\r如双方就本协议内容或其执行发生任何争议，双方应尽量友好协商解决；协商不成时，任何一方均可向本网站所在地的人民法院提起诉讼。\r\r十二、其他规定\r本协议构成双方对本协议之约定事项及其他有关事宜的完整协议，除本协议规定的之外，未赋予本协议各方其他权利。\r如本协议中的任何条款无论因何种原因完全或部分无效或不具有执行力，本协议的其余条款仍应有效并且有约束力。\r\r\r\r";
    
    UILabel *label = [UILabel createAutolayoutWithString:info fontSize:14 color:nil valueX:5 valueY:10];
    
    [clauseScrollView addSubview:label];
    
    clauseScrollView.contentSize = label.bounds.size;
    
    [self.view addSubview:clauseScrollView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end