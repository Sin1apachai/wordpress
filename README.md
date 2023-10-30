# wordpress

### การใช้งาน

ในการติดตั้ง wordpress นั้นสามารถรัน wordpress.sh เพื่อติดตั้งได้ดังขั้นตอนต่อไปนี้

ขั้นตอนที่ 1 clone repo นี้ลงเครื่องคอมพิวเตอร์
```
git clone (url repo นี้)
```

ขั้นตอนที่ 2 ไปที่ path ที่วาง repo ไว้
```
cd /path/wordpress
```

ขั้นตอนที่ 3 ทำการ gant permission ให้กับไฟล์ wordpress.sh เพื่อให้สามารถทำการ exceute ได้
```
chmod +x /path/wordpress/wordpress.sh
```

ขั้นตอนที่ 4 รันไฟล์ wordpress.sh โดย parms1 หมายถึง ชื่อ project,ชื่อ database และชื่อ path เวลา redirect, และ parms2 หมายถึง password ของ database 
```
./wordpress.sh parms1 parms2
```
