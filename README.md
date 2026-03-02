# Carousel Fix
All changes and details can be found on the link shared in the ticket: 
https://share.note.sx/dza65a6o#c6HtdgDnBz39pJiW/zXQm3yup7orCCVPSW6f3uIi+xY

# Table of changes made, and to which file: 

| \# | File / Area | Issue | Fix |
|---|-------------|-------|-----|
| 1 | Xcode Build Phases | NCE not embedded in main app | Add .appex to "Embed Foundation Extensions" |
| 2 | Xcode Build Settings | Deployment target iOS 26.1 | Lower to iOS 18.0 |
| 3 | CarouselNotificationCell.xib | customModule="carousel" | Change to "OSNotificationContentExtension" |
| 4 | MainInterface.storyboard | customModule="carousel" | Change to "OSNotificationContentExtension" |
| 5 | MainInterface.storyboard | scrollEnabled="NO" | Change to "YES" |
| 6 | MainInterface.storyboard | pagingEnabled="YES" | Change to "NO" |
| 7 | NotificationViewController.swift | Dynamic contentInset + .right.left scroll | Remove inset mutations, use .centeredHorizontally |
| 8 | NotificationViewController.swift | Uneven cell widths per index | Uniform width - 20 for all cells |

Will be making these changes to our github in order to get the most up to date working code live on that repository.
