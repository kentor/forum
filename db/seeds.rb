Forum.create([{
  :title => 'General',
  :allowed_to_view => '',
  :allowed_to_read => '',
  :allowed_to_reply => '1,2,3,4',
  :allowed_to_create => '',
  :position => 2
}, {
  :title => 'Boji Palace',
  :allowed_to_view => '1,2,3,5',
  :allowed_to_read => '',
  :allowed_to_reply => '',
  :allowed_to_create => '',
  :position => 5
}, {
  :title => 'News and Announcements',
  :allowed_to_view => '',
  :allowed_to_read => '',
  :allowed_to_reply => '1,2,3,4',
  :allowed_to_create => '1,2,3',
  :position => 1
}, {
  :title => 'Kpop',
  :allowed_to_view => '',
  :allowed_to_read => '',
  :allowed_to_reply => '1,2,3,4',
  :allowed_to_create => '',
  :position => 3
}, {
  :title => 'Videos',
  :allowed_to_view => '',
  :allowed_to_read => '1,2,3,4',
  :allowed_to_reply => '',
  :allowed_to_create => '1,2,3,5',
  :position => 4
}, {
  :title => 'Reds',
  :allowed_to_view => '1,2',
  :allowed_to_read => '',
  :allowed_to_reply => '',
  :allowed_to_create => '',
  :position => 7
}, {
  :title => 'Website Feedback',
  :allowed_to_view => '',
  :allowed_to_read => '',
  :allowed_to_reply => '1,2,3,4',
  :allowed_to_create => '',
  :position => 6
}, {
  :title => 'Closed',
  :allowed_to_view => '',
  :allowed_to_read => '',
  :allowed_to_reply => '1,2',
  :allowed_to_create => '',
  :position => 8
}])

User.create([{
  :username => 'Kentor',
  :password => 'admin',
  :password_confirmation => 'admin',
  :email => 'admin@admin.com',
  :groups => '1',
  :valid_captcha => true
}, {
  :username => 'Bot',
  :password => 'admin',
  :password_confirmation => 'admin',
  :email => 'bot@bot.com',
  :valid_captcha => true
}])

Topic.create(
  :forum_id => Forum.find_by_title('Closed').id,
  :user_id => 1,
  :title => 'Automated Ban List',
  :ip => '127.0.0.1'
)

Post.create(
  :topic_id => 1,
  :user_id => 2,
  :sub_id => 1,
  :is_thread => 1,
  :body => 'Bans will go here.',
  :ip => '127.0.0.1'
)

Setting.create(
  :admin_groups => '1',
  :mod_groups => '1,2',
  :staff_groups => '1,2,3',
  :html_groups => '1,2,3',
  :bot_id => 2,
  :ban_thread => 1
)

Smiley.create(:filename => 'smile.png',      :code => ':)'        )
Smiley.create(:filename => 'drool.gif',      :code => '(drool)'   )
Smiley.create(:filename => 'sad.png',        :code => ':('        )
Smiley.create(:filename => 'sadder.png',     :code => ':['        )
Smiley.create(:filename => 'saddest.png',    :code => ':C'        )
Smiley.create(:filename => 'nod.gif',        :code => '(nod)'     )
Smiley.create(:filename => 'laugh.png',      :code => ':D'        )
Smiley.create(:filename => 'LOL.gif',        :code => '(lol)'     ) 
Smiley.create(:filename => 'worship.gif',    :code => '(bow)'     ) 
Smiley.create(:filename => 'monkey.png',     :code => '(monkey)'  ) 
Smiley.create(:filename => 'squirrel.png',   :code => '(squirrel)') 
Smiley.create(:filename => 'bunny.png',      :code => '(bunny)'   ) 
Smiley.create(:filename => 'puke.gif',       :code => '(puke)'    ) 
Smiley.create(:filename => 'pig.png',        :code => '(pig)'     ) 
Smiley.create(:filename => 'shakehead.gif',  :code => '(shake)'   ) 
Smiley.create(:filename => 'duck.png',       :code => '(duck)'    ) 
Smiley.create(:filename => 'toilet.png',     :code => '(toilet)'  )
Smiley.create(:filename => 'hug.gif',        :code => '(hug)'     ) 
Smiley.create(:filename => 'grin.png',       :code => ':]'        ) 
Smiley.create(:filename => 'facev.png',      :code => ':>'        ) 
Smiley.create(:filename => 'drunk.gif',      :code => '(drunk)'   ) 
Smiley.create(:filename => 'tongue.png',     :code => ':p'        ) 
Smiley.create(:filename => 'shadehappy.png', :code => 'B-)'       ) 
Smiley.create(:filename => 'cat.png',        :code => '(cat)'     ) 
Smiley.create(:filename => 'dog.png',        :code => '(dog)'     ) 
Smiley.create(:filename => 'sleepyhead.gif', :code => '(sleep)'   ) 
Smiley.create(:filename => 'eek.gif',        :code => '8O'        ) 
Smiley.create(:filename => 'mute.png',       :code => ':x'        ) 