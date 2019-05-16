# ライフサイクル管理

## インスタンスをスケールアップ・スケールダウンする

Autonomous DBは簡単なコンソール操作・コマンド操作やAPI経由での

ScaleUp/Downのボタンを押します。CPU数を2にしてみましょう。CPUは時間課金(新規ライセンスで約201円、BYOLで約58円)です。


![](images/Oracle_Cloud_Infrastructure_15.png)

CPUカウントを2に増やし、Updateボタンを押します

![](images/Oracle_Cloud_Infrastructure_14.png)

画面がScaling in processになります。実行中のSQLには影響を与えません。数分でスケールアップされます。スケールダウンも同様です。


![](images/Oracle_Cloud_Infrastructure_13.png)


## インスタンスを停止する・再開する

Autonomous DBではインスタンスを停止することでOCPU課金を停止することができます。開発環境であれば夜間や休日など未利用時は停止しておくことで料金の節約ができます。

※ストレージ課金は、インスタンスを削除しないかぎり発生します。

Stopボタンを押します。


![](images/Oracle_Cloud_Infrastructure_19.png)


確認画面でもう一度Stopを押します

![](images/Oracle_Cloud_Infrastructure_18.png)

ステータスがstoppingになります。

![](images/Oracle_Cloud_Infrastructure_17.png)


stoppedになりました。

![](images/Oracle_Cloud_Infrastructure_16.png)

## インスタンスを削除する

課金を完全に停止するためには、インスタンスを削除します。

メニューからTerminateを選択します。

![](images/Oracle_Cloud_Infrastructure_23.png)


確認のため、DB名を入力します。

![](images/Oracle_Cloud_Infrastructure_22.png)

## DB接続元を制限する

Autonomous DBは強力な暗号Walletで通信データを暗号化していますが、特定のIPアドレスからの接続のためのACLを用意しています。

Access Control Listを押します

![](images/Oracle_Cloud_Infrastructure_21.png)


接続元のIP Address/CIDRを入力します。

![](images/Oracle_Cloud_Infrastructure_20.png)




# Oracle MLを使う

### ユーザーの作成

サービスコンソールを開きます。画面がポップアップするので、ブラウザでポップアップを許可してください。

![](images/Oracle_Cloud_Infrastructure.png)



Administrationのタブを開きます

![](images/Autonomous_Transaction_Processing___Overview.png)


Manage Oracle Usersのメニューを開きます

![](images/Autonomous_Transaction_Processing___Administration.png)


ユーザーの追加を行います。

![](images/Oracle_Machine_Learning_User_Administration___user_2.png)





情報を入力して右上の作成ボタンを押してください。

- ユーザー名: app
- パスワード: Oracle123456

![](images/Oracle_Machine_Learning_User_Administration___user_1.png)


### Notebookへのログイン

ユーザーができたら右上の「家」のアイコンを押して、ノートブックに移動します。

![](images/Oracle_Machine_Learning_User_Administration___user.png)





認証画面が出ましたら、先程設定したユーザー名とパスワードでログインします

![](images/Oracle_Machine_Learning_Login___Authenticate.png)


ホーム画面の、「SQL文の実行」をクリックします。

![](images/Oracle_Machine_Learning___home.png)



ノートブックが表示されたら、SQL文を入力してブロック実行の右矢印を押します。

![](images/Oracle_Machine_Learning___Notebook_Edit_1.png)

![](images/Oracle_Machine_Learning___Notebook_Edit_2.png)




