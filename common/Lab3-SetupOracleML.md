# インスタンスをスケールアップ・スケールダウンする

Autonomous DBは

ScaleUp/Downのボタンを押します。CPU数を2にしてみましょう。CPUは時間課金(約201円)です。


![](images/Oracle_Cloud_Infrastructure_15.png)


![](images/Oracle_Cloud_Infrastructure_14.png)


![](images/Oracle_Cloud_Infrastructure_13.png)


# インスタンスを停止する・再開する

Autonomous DBではインスタンスを停止することでOCPU課金を停止することができます。開発環境であれば夜間や休日など未利用時は停止しておくことで料金の節約ができます。

※ストレージ課金は、インスタンスを削除しないかぎり発生します。

![](images/Oracle_Cloud_Infrastructure_19.png)


![](images/Oracle_Cloud_Infrastructure_18.png)


![](images/Oracle_Cloud_Infrastructure_17.png)


![](images/Oracle_Cloud_Infrastructure_16.png)



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




