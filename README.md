# HNLandTax
工程搭建

设置对所有项目有效
#第一次需要输入密码，以后都不需要了 git
git config --global credential.helper osxkeychain 


# .gitignore规则不生效的解决办法

把某些目录或文件加入忽略规则，按照上述方法定义后发现并未生效，原因是.gitignore只能忽略那些原来没有被追踪的文件，如果某些文件已经被纳入了版本管理中，则修改.gitignore是无效的。那么解决方法就是先把本地缓存删除（改变成未被追踪状态），然后再提交：
git rm -r --cached .
git add .
git commit -m 'update .gitignore'


# .gitignore 文件内容如下：

# Xcode
.DS_Store
*/build/*
*.pbxuser
!default.pbxuser
*.mode1v3
!default.mode1v3
*.mode2v3
!default.mode2v3
*.perspectivev3
!default.perspectivev3
xcuserdata
profile
*.moved-aside
DerivedData
.idea/
*.hmap
*.xccheckout
*.xcworkspace
!default.xcworkspace

#CocoaPods
Pods
!Podfile
!Podfile.lock
