package jonasbark.de.stripepaymentexample

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import de.jonasbark.stripepayment.StripeDialog
import de.jonasbark.stripepayment.StripeNative

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
//        GeneratedPluginRegistrant.registerWith(this)
        StripeNative.newInstance("Native", "fake").show(supportFragmentManager, "")
        StripeDialog.newInstance("Card", "pk_test_key").show(supportFragmentManager, "")
    }
}
