<aura:application access="GLOBAL" extends="ltng:outApp" >
  <aura:dependency resource="c:hlSessions" />
  <aura:dependency resource="c:hlTabs" />
  <aura:dependency resource="c:hlCallContactEvent" type="EVENT"/>
  <aura:dependency resource="c:hlInviteContactEvent" type="EVENT"/>
  <aura:dependency resource="c:hlCopyLinkEvent" type="EVENT"/>
  <aura:dependency resource="c:hlRecentEvent" />
  <aura:dependency resource="c:hlRecentEventTimeline" />
  <aura:dependency resource="markup://force:*" type="EVENT"/>
</aura:application>
